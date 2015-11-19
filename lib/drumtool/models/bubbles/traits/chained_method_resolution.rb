module DrumTool
  module Models
    class Bubbles
      module Traits
        module ChainedMethodResolution
          as_trait do |next_responder|
            ChainedMethodResolutionNextResponder = next_responder
            
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
            
            
            def next_method_responder_object              
              send ChainedMethodResolutionNextResponder
            end
          end
        end
      end
    end
  end
end
