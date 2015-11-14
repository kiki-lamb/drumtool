class Models
require "unimidi"

class Models
	class Bubbles
	  class WorldBubble < MusicalBubble
	    attr_reader :output
	   
	    counter_bubble_attr :tick, return_value: :events, before: :play, after: :rest

	    bubble_attr :refresh, default: 16

	    bubble_attr :last_woke, default: nil

	    bubble_attr :bpm, default: 112 do
	      @tick_length = nil
	    end

	    array_bubble_attr :open_notes do |note, is_new|
	      output.puts 0x80, note[1], 100 unless is_new
	      output.puts 0x90, note[1], 100
	    end

	    def play 
	      last_woke Time.now unless last_woke

	      events.each do |event|
	        open_note event
	      end   
	    end
	    
	    def rest
	      sleep (tick_length - (Time.now - last_woke))
	      last_woke Time.now
	    end

	    def tick_length
	      @tick_length ||= 60.0/bpm/4
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