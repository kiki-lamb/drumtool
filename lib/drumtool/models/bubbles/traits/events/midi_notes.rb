module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
        module MIDINotes
          def note name, number = nil, velocity = nil, channel = nil
            name, number = number, name if Fixnum === name
            
            n = EnhancedMIDINote.new self, name: name, number: number, channel: channel, velocity: velocity

            local_notes[number] = if respond_to?(:register_note)
                                    register_note n 
                                  else
                                    n
                                  end
          end

          private       
          def events
            [ *super, *local_notes.values ]
          end

          def local_notes
            @__local_notes ||= {}
          end
        end
        end
      end
    end
  end
end

