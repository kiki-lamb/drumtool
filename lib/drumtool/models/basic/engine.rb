require "set"
require "unimidi"
require_relative "../../dsl_attrs"
require_relative "timing_scope"
require_relative "instrument"
require_relative "formatters"

module DrumTool
	module Models
		module Basic
		  class Engine
		    extend DslAttrs

		    include TimingScope

		    dsl_attr :refresh_interval, scopable: false
		    dsl_attr :bpm, after: :clear_tick_length, scopable: false

		    attr_reader :output, :open_notes

		    def initialize bpm = 128, output = UniMIDI::Output[0]
		      super nil
		      @bpm = bpm
		      @output = output
		      @open_notes = Set.new
		    end

		    def play tick, log: $stdout       
		        log << bpm << " | " << refresh_interval

		        tick = tick % loop if loop

						fill = tick % 4 == 0 ? "--" : ". "

		        log << Formatters::TableRowFormatter.call([ 
		          tick.to_s(16).rjust(16, "0"), 
		          
		          *instruments.group_by(&:short_name).map do |name, instrs| 
		            (instrs.any? do |i|
		              i.fires_at?(tick) 
		            end) ? "#{name.ljust(2)}" : fill 
		          end
		        ], [], separator: " | ") << "\n"


		        notes, length = triggers_at(tick), tick_length

		        notes.each do |note|
		          open_note note, length
		        end
		    ensure
		        sleep ( block_given?? yield : tick_length )
		        close_notes
		    end

		    def inherit other_engine
		      bpm other_engine.bpm unless bpm
		      other_engine.open_notes.each do |note|
		        open_note note
		      end
		      self
		    end

		    def close_notes
		      open_notes.each do |note|
		        close_note note
		      end       
		    end

		    def open_note note, length = tick_length, velocity = 100 # length is currently ignored.
		      close_note note, velocity
		      open_notes.add? note
		      @output.puts 0x90, note, velocity
		    end

		    def close_note note, velocity = 100
		      @output.puts 0x80, note, velocity if open_notes.delete? note     
		    end

		    def clear_tick_length
		      @tick_length = nil
		    end

		    def tick_length
		      @tick_length ||= 60.0/bpm/4
		    end

		    def to_s range = 0..15, formatter = nil # Formatters::MultiTableEngineFormatter, *a
		      if formatter
		        instance_exec range, &formatter
		      else
		        super()
		      end
		    end
		  end
		end
	end
end