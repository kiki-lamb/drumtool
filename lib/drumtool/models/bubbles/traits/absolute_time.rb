module DrumTool
	module Models
		class Bubbles
      module Traits
		  module AbsoluteTime
		    def self.included base
          base.counter_bubble_attr :time, default: 0
        end

				def initialize &b
					super nil, &b
				end
		  end
      end
		end
	end
end
