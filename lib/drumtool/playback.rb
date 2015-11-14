require "stringio"
require "topaz"
require "unimidi"
require "set"

module DrumTool
  class Playback
    class << self
      def start *a
        new(*a).start
      end
    end

		include Logging
		include MIDIOutput

    def initialize(
      filename, 
      preprocessor = Preprocessors::Preprocessor, 
      clock: nil, 
      output: UniMIDI::Output[0], 
      reset_loop_on_stop: true
    )
      @input_clock = clock
			@filename = filename
			@preprocessor = preprocessor
      @reset_loop_on_stop = reset_loop_on_stop
      @last_line_length = 2
			@tick = 0
      set_midi_output output
    end

 		def start     
			log "Waiting for MIDI clock...\nControl-C to exit\n" unless @input_clock.nil?
      clock.start
		rescue Interrupt
    end    

		def engine
		  @engine ||= eval @preprocessor.call(File.open(@filename).read)
		end

		private
    def clock      	  
      @clock ||= begin
			  Topaz::Clock.new((@input_clock ? @input_clock : engine.bpm), interval: 16, &Proc.new { tick }).tap do |c|
					c.event.stop do 
            $stdout << "\n#{self.class.name}: Stopped by user.\n"
            close_notes!
            @tick -= @tick % engine.loop if @reset_loop_on_stop and engine.loop
          end
        end
      end
    end
		
		def tick 
		  log_sep
		  tmp = a_bunch_of_logging_crap
      @last_line_length = tmp.length

		  log tmp
      close_notes! 
			trigs = engine.triggers_at(@tick)
			open_note! *trigs if engine
    ensure
      @tick += 1
    end

		def log_sep
		  io = StringIO.new
		  if engine.loop && 0 == @tick % engine.loop && engine.loop != 1
        io << "=" * (@last_line_length) << "\n"
      elsif 0 == @tick % 16 
        io << "-" * (@last_line_length) << "\n"
      end
			log io.string unless io.string.empty?
		end

		def a_bunch_of_logging_crap
      io = StringIO.new
      
      io << engine.bpm << " | " << @refresh_interval

      fill = @tick % 4 == 0 ? "--" : ". "
		
      io << Models::Basic::Formatters::TableRowFormatter.call([ 
        (engine.loop ? @tick % engine.loop : @tick).to_s(16).rjust(8, "0"), 
				
        *engine.instruments.group_by(&:short_name).map do |name, instrs| 
          (instrs.any? do |i|
            i.fires_at?(@tick)
          end) ? "#{name.ljust(2)}" : fill 
        end
      ], [], separator: " | ") << "\n"

      io.string			      
		end
  end 
end