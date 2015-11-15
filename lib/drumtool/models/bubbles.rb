module DrumTool
	module Models
	  module Bubbles
			def bubble klass = Engine,  &b
				klass.bubble &b
			end
		end
	end
end

# Current:
# Base < Events < RelativeTime < AbsoluteTime < Engine
#                              < Triggered    < Music 

# Future:
# Base < Events < Time < AbsoluteTime
#			 	 							 < RelativeTime < Engine
#											                < Triggered < Music
#
# In this model, Engine must be generate an AbsoluteTime as a parent object when initialized.



# Far future:
# Base < Events < Time < RelativeTime < TriggeredRelativeTime     <- TriggeredMusic
#			 	 							 	 						  < Music    									</
#	                     < AbsoluteTime < Engine
#
# Problem with TriggeredMusic and Music here... where to put behaviour?

# Far future:
# Base < Events < Time < RelativeTime < TriggeredTime <- Music
#	                     < AbsoluteTime < Engine
#
# Problem with TriggeredMusic and Music here... where to put behaviour?
