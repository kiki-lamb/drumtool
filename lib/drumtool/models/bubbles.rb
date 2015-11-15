module DrumTool
	module Models
	  module Bubbles
			def bubble klass = Engine,  &b
				klass.bubble &b
			end
		end
	end
end


# Context < Events < RelativeTime < AbsoluteTime < Engine
#                                 < Triggered < Music 