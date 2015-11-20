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
      (engine && engine.time) || 0
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
      @input_clock = clock
      @reset_loop_on_stop = reset_loop_on_stop
      @last_line_length = 0
      set_midi_output output
    end

 		def start          
			log "Waiting for MIDI clock #{@input_clock}...\nControl-C to exit\n" if @input_clock
      clock.start
		rescue Interrupt
    end    

		private
		attr_accessor :engine
			
		def assert_valid_engine
      true
		  # engine && engine.respond_to?(:bpm) && engine.respond_to?(:loop) && engine.respond_to?(:events_at)

		  #engine && engine.respond_to?(:events_at)
		end

		def assert_valid_engine!
      true
#		  raise RuntimeError, "Invalid engine" unless assert_valid_engine
		end

    def clock      	  
      @clock ||= begin
			  Topaz::Clock.new((@input_clock ? @input_clock : (engine.bpm || 112)), interval: 16, &Proc.new { tick }).tap do |c|
					c.event.stop do 
            $stdout << "\n#{self.class.name}: Stopped.\n"
            close_notes!
            engine.tim( time - time%engine.loop ) if engine.loop && @reset_loop_on_stop
          end
        end
      end
    end
		
		def tick
      close_notes! 
			assert_valid_engine!
			open_note! *engine.events#.tap { |x| puts "#{x.inspect}" }

		  log_sep
		  tmp = a_bunch_of_logging_crap.strip
      @last_line_length = tmp.length
		  log tmp
      engine.tick!
    end

		def log_sep
		  io = StringIO.new
		  if engine.loop && 0 == (time) % engine.loop && engine.loop != 1
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
				 engine.bpm.to_s.rjust(3),
				 (engine.loop ? time % engine.loop : time).to_i.to_s(16).rjust(4, "0"), 
         time.to_s.rjust(4," ")
      ]
		end

		def a_bunch_of_logging_crap
      io = StringIO.new      
      io << Models::Basic::Formatters::TableRowFormatter.call(log_columns, [], separator: " | ") << "\n"
      io.string			      
		end
  end 
end
