module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module ToScale
                def to_scale *a
                  scale_notes(*a).tap do |notes|
                    map = (0..11).map do |note|
                      note = (note+mod)%12 until notes.include? note
                      note
                    end
                    
                    remap *map
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
