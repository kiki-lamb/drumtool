module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Controllers
              def ctrl cc, value = 0, channel = 1
                local_controllers[cc] = EnhancedController.new self, name: nil, cc: cc, value: value, channel: channel
              end

              def ctrl! cc, channel = nil, &blk
                ctrl cc, 0, channel
                xform { (n.value = instance_eval(&blk)) if DrumTool::MIDI::Controller === self }
              end              
              
              private       
              def events
                [ *super, *local_controllers.values ]
              end
              
              def local_controllers
                @__local_controllers ||= {}
              end
            end
          end
        end
      end
    end
  end
end
