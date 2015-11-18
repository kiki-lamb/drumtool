module DrumTool
  module Models
    class Bubbles
      module Traits
        module Extendable
          def self.included base
            base.include Prepend
          end
          
				  def extend num
					  loop_ = loop

					  raise ArgumentError, "Can't extend outside a loop" unless loop_ && loop_ != 0
            
            if num > loop_
              prepend_bubble do
						    trigger((0..loop_-1))
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
