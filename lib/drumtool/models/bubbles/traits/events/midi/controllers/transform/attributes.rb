module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Controllers
              module Transform
                module Attributes
                  include Events::Transform::Helpers::Attribute[EnhancedController, :value, :__value__!]
                  
                  def ctrl! cc, channel = nil, &blk
                    ctrl cc, 0, channel
                    __value__! &blk
                  end              
                end             
              end
            end
          end
        end
      end
    end
  end
end
