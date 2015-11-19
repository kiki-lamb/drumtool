module DrumTool
  module Models
    class Bubbles
      module Traits
        module ChainedMethodResolution
          def self.included base
            base.bubble_attr :next_method_responder, default: nil
          end
          
          def method_missing name, *a, &b
            if next_method_responder_object && next_method_responder_object.respond_to?(name)
              next_method_responder_object.send name, *a, &b
            else
              super
            end
          end
          
          def respond_to? name, all = false
            super(name, all) || (next_method_responder_object && next_method_responder_object.respond_to?(name, all))
          end

          private
          def next_method_responder_object
            return nil unless next_method_responder
            send next_method_responder
          end
        end
      end
    end
  end
end
