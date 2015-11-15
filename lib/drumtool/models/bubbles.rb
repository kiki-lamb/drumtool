module DrumTool
	module Models
	  module Bubbles
			def bubble klass = Track,  &b
				klass.bubble &b
			end
		end
	end
end

# Current:
# Base < Timeline < RelativeTimeline < Pattern(Triggered, Events, Notes)
#			 	 					< AbsoluteTimeline < Track(Events)																		 	 

																		 	 