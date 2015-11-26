module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Controllers
              def ctrl name, cc = nil, value = nil, channel = nil
                value, cc, name = cc, name, nil if Fixnum === name
                local_controllers[cc] = EnhancedController.new self, name: name, cc: cc, value: value, channel: channel
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
