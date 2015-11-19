module DrumTool
  module Models
    class Bubbles
      module Traits
        module ClockReverse
					def self.included base
				    base.bubble_toggle :reverse!
				  end														
        end
      end
    end
  end
end
