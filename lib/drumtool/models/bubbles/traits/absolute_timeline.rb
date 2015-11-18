module DrumTool
	module Models
		class Bubbles
      module Traits
		  module AbsoluteTime
		    def self.included base
          base.counter_bubble_attr :time, default: 0
        end

				def initialize *a, &b
					super nil, *a, &b
				end
		  end
      end
		end
	end
end
