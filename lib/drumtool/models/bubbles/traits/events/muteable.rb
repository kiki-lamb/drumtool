module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module Muteable
            def self.prepended base
              base.bubble_toggle :mute
            end
            
            def events(*klasses)
              [ *(super(*klasses) unless mute?) ]
            end
          end
        end
      end
    end  
  end
end
