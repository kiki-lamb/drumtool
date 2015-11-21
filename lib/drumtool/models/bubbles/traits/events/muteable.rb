module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module Muteable
            def self.prepended base
              base.bubble_toggle :mute
            end
            
            def events
              [ *(super unless mute?) ]
            end
          end
        end
      end
    end  
  end
end
