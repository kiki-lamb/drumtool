module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
          module Absolute
            as_trait do |ratio = 1|
              define_method :time! do
                @time ||=0
                @time += 1
              end              
              
              define_method :htime= do |x|
                @time ||= 0 
                @time = x
              end
              
              define_method :time do
                @time ||= 0
                @time / ratio
              end
              
              define_method :htime do
                @time
              end
              
              define_method :exact? do
                htime % ratio == 0
              end

              define_method :ltime do
                time
              end
            end
          end
        end
      end
    end
  end
end
