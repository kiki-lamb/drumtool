module DrumTool
  module Models
    class Bubbles
      module Traits
        module MethodResolutionCascading
          def self.included base
						base.bubble_attr :next_responder, default: nil
          end
          
          ################################################################################
          # Method resolution
          ################################################################################
          
          def method_missing name, *a, &b
            obj = send(next_responder) if next_responder
            
            if obj.respond_to?(name)
              obj.send name, *a, &b
            else
              super
            end
          end
          
          def respond_to? name, all = false
            obj = send(next_responder) if next_responder

            super(name, all) || (obj && obj.respond_to?(name, all))
          end
        end
      end
    end
  end
end
