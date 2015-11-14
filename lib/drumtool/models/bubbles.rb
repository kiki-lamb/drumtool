module DrumTool
	module Models
	  module Bubbles
			def bubble klass = WorldBubble,  &b
				klass.bubble &b
			end
		end
	end
end