module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
          module Events
            module Triggered
              module DropAndTake
				        def take num
                  untrigger(Proc.new { |t| t >= num })
					      end
                
                def drop num
                  untrigger(Proc.new { |t| t < num })
                end
				      end
            end
          end
        end
      end
    end
  end
end
