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

			@engine = eval preprocessor.call(File.open(filename).read)

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
		  @engine
		end

		private
    def clock      	  
      @clock ||= begin
			  Topaz::Clock.new((@input_clock ? @input_clock : engine.bpm), interval: 16) do
			    begin
					  a_bunch_of_logging_crap (0)
        	  close_notes! 
						trigs = engine.triggers_at(@tick)
			  	  open_note! *trigs if engine
          ensure
            @tick += 1
          end
        end.tap do |c|
					c.event.stop do 
            $stdout << "\n#{self.class.name}: Stopped by user.\n"
            close_notes!
            @tick -= @tick % engine.loop if @reset_loop_on_stop and engine.loop
          end
        end
      end
    end
		
		def a_bunch_of_logging_crap refresh_time
      io = StringIO.new
      
      if engine.loop && 0 == @tick % engine.loop && engine.loop != 1
        io << "=" * (@last_line_length-2) << "\n"
      elsif 0 == @tick % 16 
        io << "-" * (@last_line_length-2) << "\n"
      end

      io << refresh_time.to_s[0..4].ljust(5,"0") << " | "

      io << engine.loop << " | " 
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

      @last_line_length = io.string.length

      log io.string
		end
  end 
end