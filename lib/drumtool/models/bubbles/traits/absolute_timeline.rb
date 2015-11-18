module DrumTool
	module Models
		class Bubbles
      module Traits
		  module AbsoluteTime
		    def self.included base
          base.counter_bubble_attr :time
        end

				def initialize *a, &b
				  time 0
					super nil, *a, &b
				end
		  end
      end
		end
	end
end
