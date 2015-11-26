module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
          module Relative
            as_trait do |ratio = 1, prefix = :nil|
              define_method :loop do |x = nil|
                @loop = x ? x : nil
              end              
              
              define_method :rotate do |x = nil|
                if x
                  @rotate = x
                else
                  @rotate ||= 0
                end
              end
              
              define_method :shift do |x = nil|
                if x
                  @shift = x
                else
                  @shift ||= 0
                end
              end
              
              define_method :scale do |x = nil|
                if x
                  @scale = x
                else
                  @scale ||= 0
                end
              end
              
              define_method :time do
                time_   = parent.time
                loop_   = loop
                rotate_ = rotate
                shift_  = shift
                scale_  = scale
                
                e = (time_ * (2**(-scale_))).to_f - rotate_
                e %= loop_ if loop_
                e -= shift_
              end              
            end
          end
        end
      end
    end
  end
end
