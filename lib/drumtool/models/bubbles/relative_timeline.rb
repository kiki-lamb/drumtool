module DrumTool
	module Models
		module Bubbles
		  class RelativeTimeline < Instant

			  bubble_attr :loop, default: nil
				adding_bubble_attr :rotate
				adding_bubble_attr :shift
				adding_bubble_attr :scale

				def time
				  locate base_time
				end

				def locate base_time     
				  e_time = (base_time * (2**(-scale))).to_f
					e_time -= rotate
					e_time %= loop if loop
					e_time -= shift
					e_time #.tap { |x| puts "#{self} locates #{base_time} at #{x}" }
				end

				private
				def base_time
				  parent.time
				end
		  end
		end
	end
end
