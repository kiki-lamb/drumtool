module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Helpers
              module ScaleNotes                
                def scale_notes note_name, type = :minor, mod = 1, *a
								  root = (Note.new(note_name.to_s)-(@__down__ = NoteInterval.new(60)))
									
                  if Fixnum === note_name
                    [ note_name, type, mod, *a ]
                  else
                    root.send("#{type}_scale").note_values.map { |x| x % 12 }
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

