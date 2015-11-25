module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module ToScale
                def to_scale *a
                  remap *map_for_scale(scale_notes(*a))
                end

                private
                def note_to_scale note, in_notes, mod = 1
                  until in_notes.include?(note) || in_notes.include?(note-(12*mod))
                    note += mod
                  end
                  note
                end
                
                def map_for_scale scale_notes, mod = 1
                  (0..11).map do |note|
                    note_to_scale(note + scale_notes.first, scale_notes, mod) 
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
