module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module ToScale
                def rescale! *a
                  __to_scale__ true, *a
                end

                def to_scale! *a
                  __to_scale__ false, *a
                end

                private
                def __to_scale__ ordered, note_name, type = :minor, modsym = :+, *a
                  map = map_for_scale(scale_notes(note_name, type, *a, ordered: ordered), mod_from_sym(modsym))
                  puts "MAP: #{map.inspect}"
                  remap! *map
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
                
                def map_for_scale scale_notes, mod = 1
                  (0..11).map do |note|
                    note += mod until scale_notes.include?(note) || scale_notes.include?(note-12*mod)
                    note
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
