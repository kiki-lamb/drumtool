module DrumTool
	module Models
		module Bubbles
		  module Timeline
			  def self.included base 
			 		base.bubble_attr :loop, default: nil
		    	base.bubble_attr :rotate
		    	base.bubble_attr :shift
		    	base.bubble_attr :scale
				end

				def time
				  locate base_time
				end

				private
				def base_time
				  raise NotImplementedError
				end

				def locate base_time				 
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
