module DrumTool
	module Models
		class Bubbles
		  class RelativeTime < Instant

			  bubble_attr :loop, default: nil
				adding_bubble_attr :rotate
				adding_bubble_attr :shift
				adding_bubble_attr :scale

				def time
				  locate base_time
				end

				def locate base_time     
				  ((base_time.to_f * 2**-scale) - rotate) % (loop || base_time +1 ) - shift
				end

				private
				def base_time
				  parent.time
				end
		  end
		end
	end
end
