module DrumTool
	module Models
		module Bubbles
		  class AbsoluteTimeline < Base
			  include Timeline
		    counter_bubble_attr :tick

				private
		    def base_time 
				  tick
				end
		  end
		end
	end
end
