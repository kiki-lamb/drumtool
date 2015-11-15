module DrumTool
	module Models
	  module Bubbles
			def bubble klass = AbsoluteTimeBubble,  &b
				klass.bubble &b
			end
		end
	end
end


# Bubble < RelativeTimeBubble < AbsoluteTimeBubble
#                             < TriggeredBubble < MusicBubble 