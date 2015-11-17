module DrumTool
	module Models
		class LighterBubbles
		  class RelativeTime < Instant

			  bubble_attr :loop, default: nil
				adding_bubble_attr :rotate
				adding_bubble_attr :shift
				adding_bubble_attr :scale

				def time
				  locate base_time
				end

				def locate time     
				  e = (time * (2**(-scale))).to_f - rotate
					e %= loop if loop
					e -= shift
				end

				private
				def base_time
				  parent.time
				end
		  end
		end
	end
end
