module DrumTool
	module Models
		module Bubbles
		  class EngineBubble < TimeBubble
		    counter_bubble_attr :tick, return_value: :events, before: :play
		    
		    def initialize *a, &b
		      super *a, &b
		    end

		    def bubble &b
		      MusicBubble.new(self).build(&b)
		    end
		  end
		end
	end
end