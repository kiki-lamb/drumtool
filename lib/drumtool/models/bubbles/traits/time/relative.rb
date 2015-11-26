module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
          module Relative
            as_trait do |ratio = 1|
              define_method :loop do |x = nil|
#                puts "LOOP #{x}"
                @loop ||= nil
                @loop = x*ratio if x
                @loop # .tap { |l| puts "LOOP GIVES #{l}" }

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
                htime % ratio == 0
              end
              
              define_method :lores_time do
                __locate_time__ ratio, parent.htime, loop, rotate, shift, scale
              end              

              define_method :htime do
                __locate_time__ 1, parent.htime, loop, rotate, shift, scale
              end              

              define_method :time do
                lores_time
              end

              private
              define_method :__locate_time__ do |ratio_, time_, loop_, rotate_, shift_, scale_|
                time_   /= ratio_
                loop_   /= ratio_ if loop_
                rotate_ /= ratio_
                shift_  /= ratio_
                scale_  /= ratio_
                
#                puts "R #{ratio_} L #{loop}"
                
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
