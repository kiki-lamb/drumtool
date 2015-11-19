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

			def conditional_attr name, if_, left, right
			  define_method name do
 				  (send(if_) && send_or_get(left)) || send_or_get(right)
				end
			end
    end

    def time
      (engine && engine.tick) || 0
    end
    
    def send_or_get v
      case v
      when Array
        v.dup.inject(self) do |o, sym|
          sym[0] == "@" ? o.instance_variable_get(v) : o.send(sym)
        end
      when Symbol
        v[0] == "@" ? instance_variable_get(v) : send(v)
      else 
        v
      end
    end

		include Logging
		include MIDIOutput

    def initialize(
		  engine = nil,
      clock: nil, 
      output: UniMIDI::Output[0], 
      reset_loop_on_stop: true,
			fixed_bpm: 128,
			fixed_loop: 16
    )
		  @engine = engine

		  @fixed_bpm = fixed_bpm
		  @fixed_loop = fixed_loop

      @input_clock = clock
      @reset_loop_on_stop = reset_loop_on_stop
      @last_line_length = 0
      set_midi_output output
    end

 		def start    
			log "Waiting for MIDI clock...\nControl-C to exit\n" unless @input_clock.nil?
      clock.start
		rescue Interrupt
    end    

		private
		attr_accessor :engine
		conditional_attr :bpm, :assert_valid_engine,  [ :engine, :bpm ], :@fixed_bpm
		conditional_attr :loop, :assert_valid_engine, [ :engine, :loop ],  :@fixed_loop
			
		def assert_valid_engine
		  # engine && engine.respond_to?(:bpm) && engine.respond_to?(:loop) && engine.respond_to?(:events_at)

		  #engine && engine.respond_to?(:events_at)
		end

		def assert_valid_engine!
#		  raise RuntimeError, "Invalid engine" unless assert_valid_engine
		end

    def clock      	  
      @clock ||= begin
			  Topaz::Clock.new((@input_clock ? @input_clock : bpm), interval: 16, &Proc.new { tick }).tap do |c|
					c.event.stop do 
            $stdout << "\n#{self.class.name}: Stopped by user.\n"
            close_notes!
            engine.parent.time( time - time%loop ) if @reset_loop_on_stop
          end
        end
      end
    end
		
		def tick
      close_notes! 
			assert_valid_engine!
      engine.tick!
			open_note! *engine.events.tap { |x| puts "#{x.inspect}" }
		  log_sep
		  tmp = a_bunch_of_logging_crap.strip
      @last_line_length = tmp.length
		  log tmp
    end

		def log_sep
		  io = StringIO.new
		  if loop && 0 == (time) % loop && loop != 1
        io << "=" * (@last_line_length) << "\n"
      elsif 0 == time % 16 
        io << "-" * (@last_line_length) << "\n"
      end
			log io.string unless io.string.empty?
		end

		def log_columns
		  fill = time % 4 == 0 ? "__" : ". "
	    tail = if engine.respond_to?(:displayed_notes)
               engine.displayed_notes.map do |note|
                 if note
                   note.to_s.upcase
                 else
                   fill
                 end
               end
             elsif engine.respond_to?(:instruments)
               (engine.instruments.group_by(&:short_name).map do |name, instrs| 
                  (instrs.any? do |i|
                     i.fires_at?(time)
                   end) ? "#{name.ljust(2)}" : fill 
                end)
             else
               []
             end

		  [          
				 *tail, 
				 (loop ? time % loop : time).to_i.to_s(16).rjust(8, "0"), 
				 bpm.to_s.rjust(3)
      ]
		end

		def a_bunch_of_logging_crap
      io = StringIO.new      
      io << Models::Basic::Formatters::TableRowFormatter.call(log_columns, [], separator: " | ") << "\n"
      io.string			      
		end
  end 
end
