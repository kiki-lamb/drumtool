module DrumTool
	module Models
	  module Bubbles
			def bubble klass = EngineBubble,  &b
				klass.bubble &b
			end
		end
	end
end