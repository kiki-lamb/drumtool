module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module ToScale
                def to_scale! *a
                  __to_scale__ true, *a
                end

                def rescale! *a
                  __to_scale__ false, *a
                end

                private
                def __to_scale__ ordered, note_name, type = :minor, modsym = :-, *a
                  remap! *map_for_scale((ordered ? root_note(note_name).value : 0), scale_notes(note_name, type, *a), mod_from_sym(modsym))
                end
                
                def map_for_scale root, scale_notes, mod = 1
                  tmp = (0..11).map do |note|
                    note += mod until scale_notes.include?(note) || scale_notes.include?(note-12*mod)
                    note
                  end
                  
                  until tmp.first == root
                    tmp.push tmp.shift+12
                  end
                  
                  tmp
                end

                def mod_from_sym sym
                  if :+ == sym
                    1
                  elsif :- == sym
                    -1
                  else
                    raise ArgumentError, "Invalid mod symbol"
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
