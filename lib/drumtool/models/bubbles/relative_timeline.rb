module DrumTool
	module Models
		module Bubbles
		  class RelativeTimeline < Timeline
				private
				def base_time
				  parent.time
				end
		  end
		end
	end
end
