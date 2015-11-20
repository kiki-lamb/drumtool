module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
          module Relative
            module EnhancedLooping
              def self.prepended base
                base.prepend Traits::Tree::Prepend
                base.bubble_toggle :reverse
                base.bubble_toggle :hard_reverse
              end

          def time
            raise RuntimeError, "Can't reverse outside a loop" if (reverse? || hard_reverse?) unless least_loop
            s = super
            s = local_loop - s - 1 if (hard_reverse? && local_loop)
            s = least_loop - s - 1 if reverse? || (hard_reverse? && ! local_loop)
            s
          end

          def loop num = nil
            if num.nil?
              super num
            elsif num > 0
              super num
            elsif num < 0
					    raise ArgumentError, "Can't right-loop outside a loop" unless least_loop && least_loop != 0

                num += least_loop
                shift -num
                super(least_loop - num)
            end
          end
          
				  def stretch num
					  local_loop = loop
					  raise ArgumentError, "Stretch must follow a local loop loop" unless local_loop && local_loop != 0
            
            if num > local_loop
              prepend_bubble do
						    untrigger(Proc.new { |t| t >= local_loop })
                loop num
						  end
            elsif num < 0
              num *= -1
              prepend_bubble do
                tmp = num - local_loop
                shift tmp
                trigger((0..tmp+1))
                untrigger(Proc.new { |t| t > (tmp + 1) })
                loop num
						  end
            else
              loop num
            end
					end

          private
          # Getter
          def local_loop
            loop
          end
          
          def least_loop
            [ self, *ancestors ].map do |a|
              a.loop if a.respond_to? :loop
            end.compact.min
          end         
				end
      end
    end
  end
end

end
end
