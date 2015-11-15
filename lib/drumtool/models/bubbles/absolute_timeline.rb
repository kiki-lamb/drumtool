module DrumTool
	module Models
		module Bubbles
		  class AbsoluteTimeline < Instant
		    counter_bubble_attr :time

				def initialize *a, &b
				  time 0
					super nil, *a, &b
				end
		  end
		end
	end
end
