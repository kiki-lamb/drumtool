module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
        module Absolute

          def time!
            @time ||=0
            @time += 1
          end              
          
          def time x = nil
            @time ||= 0
            @time = x if x
            @time
          end

          def hires_time
            time
          end
          
          def reverse!
            reverse_time!
          end
        end
      end
    end
  end
end
end
