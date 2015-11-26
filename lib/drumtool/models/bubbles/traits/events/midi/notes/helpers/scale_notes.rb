module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              module Helpers
                module ScaleNotes
                  private
                  def root_note note_name
                    (Note.new(note_name.to_s)-(@__down__ = NoteInterval.new(60)))
                  end
                  
                  def scale_notes note_name, type = :minor, *a
                    tmp = if Fixnum === note_name
                          [ note_name, type, *a ]
                          else
                            root = root_note note_name
                            root.send("#{type}_scale").note_values.map { |x| x % 12 }.sort
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
end
