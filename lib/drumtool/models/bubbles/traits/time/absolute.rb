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
              
              define_method :hires_time= do |x|
                @time ||= 0 
                @time = x
              end
              
              define_method :time do
                @time ||= 0
                @time / ratio
              end
              
              define_method :hires_time do
                @time
              end
              
              define_method :lores_time do
                time
              end
            end
          end
        end
      end
    end
  end
end
