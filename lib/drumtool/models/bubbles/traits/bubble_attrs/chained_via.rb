module DrumTool
  module Models
    class Bubbles
      module Traits
        module BubbleAttrs
          module ChainedVia
          module ClassMethods            
            def cumulative_bubble_attr name, default: 0, &after
              bubble_attr name, default: default, accessor: "local_#{name}", &after
              
              # Getter
              define_method name do |v = nil|
                send("local_#{name}", v) + (next_bubble_attr_responder_object ? next_bubble_attr_responder_object.send(name) : 0)
              end
            end
            
            def proximal_bubble_toggle name, &after
              bubble_toggle name, getter_name: "local_#{name}", &after
              
              # Getter
              define_method "#{name}?" do |v = nil|
                send("local_#{name}?") || 
                  ( next_bubble_attr_responder_object && next_bubble_attr_responder_object.respond_to?("#{name}?") && next_bubble_attr_responder_object.send("#{name}?"))
              end
            end
          end

          as_trait do |next_responder|
            extend ClassMethods

            define_method :next_bubble_attr_responder_object do
              send next_responder if next_responder
            end
          end
        end
      end
    end
  end
end

end
