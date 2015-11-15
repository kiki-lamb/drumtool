module DrumTool
	module Models
		module Bubbles
		  class AbsoluteTimeline < Timeline
		    counter_bubble_attr :tick

				private
		    def base_time 
				  tick
				end
		  end
		end
	end
end
