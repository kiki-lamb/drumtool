module DrumTool
  module Models
    class Bubbles
      module Traits
        module Extend
          def self.included base
            base.include Prepend
          end

          def rextend num
					  loop_ = loop

					  raise ArgumentError, "Can't extend outside a loop" unless loop_ && loop_ != 0
            
            if num > loop_
              prepend_bubble do
                tmp = num - loop_
                shift tmp
                trigger((0..tmp+1))
                untrigger(Proc.new { |t| t > (tmp + 1) })
                loop num
						  end
            else
              raise NotImplementedError, "Can't do this yet."
            end
          end
          
				  def extend num
					  loop_ = loop

					  raise ArgumentError, "Can't extend outside a loop" unless loop_ && loop_ != 0
            
            if num > loop_
              prepend_bubble do
						    untrigger(Proc.new { |t| t > loop_ })
                self.loop num
						  end
            else
              loop num
            end
					end
				end
      end
    end
  end
end
