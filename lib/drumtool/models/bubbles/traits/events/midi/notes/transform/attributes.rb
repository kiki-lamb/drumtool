module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              module Transform
                module Attributes                  
                  %i{ note velocity number channel }.each do |sym|
                    include Events::Transform::Helpers::Attribute[EnhancedNote, sym]
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

