module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
        module Relative
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
            e #.tap { |t| puts "SEE TIME #{t}" }
          end
        end
      end
    end
  end
  end
end
