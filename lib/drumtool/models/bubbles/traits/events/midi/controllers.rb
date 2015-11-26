module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Controllers
              def self.prepended base 
                base.prepend ProvidesEvents[:local_controllers_values, EnhancedController]
              end

              def ctrl cc, value = 0, channel = 1
                local_controllers[cc] = EnhancedController.new self, name: nil, cc: cc, value: value, channel: channel
              end
              
              private       
              def local_controllers_values
                local_controllers.values
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
