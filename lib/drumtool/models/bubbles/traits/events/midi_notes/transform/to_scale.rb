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
                def __to_scale__ *a
                  remap! *map_for_scale(*a)
                end

                def map_for_scale from_root, note_name, type = :minor, modsym = :-, *a
                  mod = case modsym
                        when :+
                          1
                        when :-
                          -1
                        else
                          raise ArgumentError, "Invalid mod symbol"
                        end                 
                  notes = scale_notes(note_name, type, *a)
                  root  = from_root ? root_note(note_name).value : 0
                  
                  map = (0+root..11+root).map do |note|
                    until notes.include?(note) || notes.include?(note+12) || notes.include?(note-12) 
                      note += mod
                    end
                    note
                  end
                  
                  map
                end
              end
            end
          end
        end
      end
    end
  end
end
