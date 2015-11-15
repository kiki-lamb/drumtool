module DrumTool
	module Models
		module Bubbles
		  class RelativeTimeline < Instant

			  bubble_attr :loop, default: nil
				bubble_attr :rotate
				bubble_attr :shift
				bubble_attr :scale

				def time
				  locate base_time
				end

				def locate base_time     
				  e_time = (base_time * (2**(-scale))).to_f
					e_time -= rotate
					e_time %= loop if loop
					e_time -= shift
					e_time
				end

				private
				def base_time
				  parent.time
				end
		  end
		end
	end
end
