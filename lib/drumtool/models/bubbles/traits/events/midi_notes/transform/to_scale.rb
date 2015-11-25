module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module ToScale
                def to_scale note_name, type = :minor, *a
                  scale_notes = if Fixnum === note_name
                                   [ note_name, type, *a ]
                                 else
                                   lowest(note).send("#{type}_scale").note_values.map { |x| x % 12 }
                                end
                  map = (0..11).map do |note|
                    note = (note+mod)%12 until scale_notes.include? note
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
