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
                  mod = case modsym
                        when :+
                          1
                        when :-
                          -1
                        else
                          raise ArgumentError, "Invalid mod symbol"
                        end

                  remap! *map_for_scale(scale_notes(note_name, type, *a), (ordered ? root_note(note_name).value : 0), mod)
                end
                
                def map_for_scale scale_notes, root = 0, mod = 1
                  tmp = (0..11).map do |note|
                    note += mod until scale_notes.include?(note) || scale_notes.include?(note-12*mod)
                    note
                  end
                  
                  until tmp.first == root
                    tmp.push tmp.shift+12
                  end
                  
                  tmp
                end
              end
            end
          end
        end
      end
    end
  end
end
