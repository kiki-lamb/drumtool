require "unimidi"

module DrumTool
	module Models
		module Bubbles
		  class WorldBubble < MusicalBubble
		    bubble_attr :refresh, default: 16
		    bubble_attr :bpm, default: 112
		    counter_bubble_attr :tick, return_value: :events, before: :play

		    array_bubble_attr :open_notes do |note, is_new|
		      output.puts 0x80, note[1], 100 unless is_new
		      output.puts 0x90, note[1], 100
		    end

		    attr_reader :output
		   
		    def play 
		      events.each do |event|
		        open_note event
		      end   
		    end
		    
		    def initialize *a, output: UniMIDI::Output[0], &b
		      @output = output
		      super *a, &b
		    end

		    def bubble &b
		      ChildBubble.new(self).build(&b)
		    end
		  end
		end
	end
end