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
# Base < Events < Time < AbsoluteTime
#			 	 							 < RelativeTime < Track
#											                < Triggered < Pattern
#
# In this model, Track must be generate an AbsoluteTime as a parent object when initialized.



# Far future:
# Base < Events < Time < RelativeTime < TriggeredRelativeTime     <- TriggeredPattern
#			 	 							 	 						  < Pattern    									</
#	                     < AbsoluteTime < Track
#
# Problem with TriggeredPattern and Pattern here... where to put behaviour?

# Far future:
# Base < Events < Time < RelativeTime < TriggeredTime <- Pattern
#	                     < AbsoluteTime < Track
#
# Problem with TriggeredPattern and Pattern here... where to put behaviour?
