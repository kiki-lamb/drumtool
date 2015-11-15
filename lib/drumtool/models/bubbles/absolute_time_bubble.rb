module DrumTool
	module Models
		module Bubbles
		  class AbsoluteTimeBubble < RelativeTimeBubble
		    counter_bubble_attr :tick, return_value: :events
		    
		    def bubble &b
		      MusicBubble.new(self).build(&b)
		    end
		  end
		end
	end
end
