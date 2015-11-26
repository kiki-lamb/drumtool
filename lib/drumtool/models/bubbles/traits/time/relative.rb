module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
          module Relative
            as_trait do |ratio = 1|
              define_method :loop do |x = nil|
                @loop = x ? x*ratio : nil
              end              
              
              define_method :rotate do |x = nil|
                if x
                  @rotate = x*ratio
                else
                  @rotate ||= 0
                end
              end
              
              define_method :shift do |x = nil|
                if x
                  @shift = x*ratio
                else
                  @shift ||= 0
                end
              end
              
              define_method :scale do |x = nil|
                if x
                  @scale = x*ratio
                else
                  @scale ||= 0
                end
              end

              define_method :exact? do
                hires_time % ratio == 0
              end
              
              define_method :lores_time do
                __locate_time__ ratio, parent.hires_time, loop, rotate, shift, scale
              end              

              define_method :hires_time do
                __locate_time__ 1, parent.hires_time, loop, rotate, shift, scale
              end              

              define_method :time do
                lores_time
              end

              private
              def __locate_time__ ratio_, time_, loop_, rotate_, shift_, scale_
                time_   /= ratio_
                loop_   /= ratio_ if loop_
                rotate_ /= ratio_
                shift_  /= ratio_
                scale_  /= ratio_
                
                e = (time_ * (2**(-scale_))) - rotate_
                e %= loop_ if loop_
                e -= shift_
                e
              end              
            end
          end
        end
      end
    end
  end
end
