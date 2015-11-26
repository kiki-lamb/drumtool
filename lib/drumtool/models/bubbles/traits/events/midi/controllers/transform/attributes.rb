module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Controllers
              module Transform
                module Attributes
                  def ctrl! cc, channel = nil, &blk
                    ctrl cc, 0, channel
                    xform do |ctrl|
                      (ctrl.value = instance_eval(&blk)) if EnhancedController === self
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
end
