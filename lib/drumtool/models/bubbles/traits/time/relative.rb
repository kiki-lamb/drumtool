module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
        module Relative
          def self.included base        
            base.bubble_attr :loop, default: nil
            base.bubble_attr :rotate
            base.bubble_attr :shift
            base.bubble_attr :scale
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
end
