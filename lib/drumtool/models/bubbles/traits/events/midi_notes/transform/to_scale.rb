module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module ToScale
                def to_scale note_name, type = :minor, modsym = :+, *a
                  remap *map_for_scale(scale_notes(note_name, type, *a, ordered: true), mod_from_sym(modsym))
                end

                def to_scale! note_name, type = :minor, modsym = :+, *a
                  remap *map_for_scale(scale_notes(note_name, type, *a, ordered: false), mod_from_sym(modsym))
                end

                private

                def mod_from_sym sym
                  if :+ == sym
                    1
                  elsif :- == sym
                    -1
                  else
                    raise ArgumentError, "Invalid mod symbol"
                  end
                end
                
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
