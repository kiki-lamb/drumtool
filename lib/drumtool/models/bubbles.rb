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
# Base <  Timeline < AbsoluteTimeline
#			 	 					 < RelativeTimeline < Track(Events)
#											                < Triggered(Events) < Pattern(Notes)
#
# In this model, Track must be generate an AbsoluteTimeline as a parent object when initialized.



# Far future:
# Base < Events < Timeline < RelativeTimeline < TriggeredRelativeTimeline     <- TriggeredPattern
#			 	 							 	 						  < Pattern    									</
#	                     < AbsoluteTimeline < Track
#
# Problem with TriggeredPattern and Pattern here... where to put behaviour?

# Far future:
# Base < Events < Timeline < RelativeTimeline < TriggeredTimeline <- Pattern
#	                     < AbsoluteTimeline < Track
#
# Problem with TriggeredPattern and Pattern here... where to put behaviour?
