module DrumTool
  module Models
    class Bubbles
      module Traits
        module ChainedMethodResolution
          as_trait do |next_responder|
            define_method :next_method_responder_object do
              send next_responder if next_responder
            end
            
            def method_missing name, *a, &b
              puts "MISSING: #{name}"
              if next_method_responder_object && next_method_responder_object.respond_to?(name)
                next_method_responder_object.send name, *a, &b
              else
                super
              end
            end
            
            def respond_to? name, all = false
              super(name, all) || (next_method_responder_object && next_method_responder_object.respond_to?(name, all))
            end
                       
          end
        end
      end
    end
  end
end
