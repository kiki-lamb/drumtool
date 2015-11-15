module DrumTool
	module Models
	  module Bubbles
			def bubble klass = AbsoluteTimeBubble,  &b
				klass.bubble &b
			end
		end
	end
end


# Bubble < EventBubble < RelativeTimeBubble < AbsoluteTimeBubble
#                                           < TriggeredBubble < MusicBubble 