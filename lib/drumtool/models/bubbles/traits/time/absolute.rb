module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
        module Absolute
          def rate= x
            @rate = x.to_f
          end

          def rate
            @rate ||= 1
          end

          def time x = nil
            @time ||= 0
            @time = x if x
            @time / rate
          end

          def time!
            @time ||= 0
            @time += 1
          end
          
#          def self.included base
#            base.counter_bubble_attr :time, default: 0 ## , reversor: :reverse!
#          end

          def reverse!
            reverse_time!
          end
        end
      end
    end
  end
end
end
