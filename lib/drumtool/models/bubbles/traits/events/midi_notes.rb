module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
        module MIDINotes
          def note name, number = nil, velocity = nil, channel = nil, &b
            name, number = number, name if Fixnum === name
            
            n = EnhancedMIDINote.new self, name: name, number: number, channel: channel, velocity: velocity, &b

            local_notes[number] = if respond_to?(:register_note)
                                    register_note n 
                                  else
                                    n
                                  end
          end

          def notes
            local_notes.values.map(&:process!) # .tap { |xs| puts "#{self}.XS: #{xs}" }
          end
          
          private       
          def local_events            
            [ *notes, *super ]  #.tap { |x| puts "#{self} MidiNotes#events OUT = #{x.inspect}" }
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

