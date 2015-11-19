module DrumTool
	module Models
		class Bubbles
      module Traits
		    module AbsoluteTime
          def self.included base
            base.counter_bubble_attr :time, default: 0 # , reversor: :reverse!
          end

          def reverse!
            reverse_time!
          end
        end
      end
		end
	end
end
