module DrumTool
	module Models
		class Bubbles
      module Traits
		    module RelativeTime
			    def self.included base				
			      base.bubble_attr :loop, default: nil
					  base.adding_bubble_attr :rotate
					  base.adding_bubble_attr :shift
					  base.adding_bubble_attr :scale
				  end
          
				  def time
				    e = (parent.time * (2**(-scale))).to_f - rotate
					  e %= loop if loop
					  e -= shift
				  end
        end
      end
		end
	end
end
