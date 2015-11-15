module DrumTool
	module Models
		module Bubbles
		  class RelativeTime < EventBubble
		    bubble_attr :loop, default: nil
		    bubble_attr :rotate
		    bubble_attr :shift
		    bubble_attr :scale

		    def time  
					relativize base_time
		    end

				private
				def base_time
				  parent.time
				end

				def relativize base_time				 
		      e_time = (base_time * (2**(-scale))).to_f
		      e_time -= rotate
		      e_time %= loop if loop
		      e_time -= shift
		      e_time
				end
		  end
		end
	end
end
