require "set"
require "unimidi"

module DrumTool
	module Models
		module Basic
		  class Engine
		    include TimingScope

		    dsl_attr :refresh_interval, scopable: false
		    dsl_attr :bpm, after: :clear_tick_length, scopable: false

		    attr_reader :output, :open_notes

		    def initialize output, bpm = 128
		      super nil
		      @bpm = bpm
		      @output = output
		      @open_notes = Set.new
		    end

		    def play tick, log: $stdout       
		      tick = tick % loop if loop

		      triggers_at(tick).tap do |notes|
		        close_notes

		        notes.each do |note|
		          open_note note
		        end
          end
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

		    def open_note note, velocity = 100
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