module DrumTool
	module Models
	  module Bubbles
			def track klass = Track,  *a, &b
				klass.new timeline, *a, &b
			end

			def timeline *a, &b
				AbsoluteTimeline.new *a, &b
			end
		end
	end
end

# Current:
# Base < Instant < RelativeTimeline < Pattern(Triggered, Events, Notes)
#			 	 				 < AbsoluteTimeline < Track(Events)																		 	 

																		 	 