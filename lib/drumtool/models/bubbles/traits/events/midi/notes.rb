module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              def note name, number = nil, velocity = nil, channel = nil
                name, number = number, name if Fixnum === name
                
                n = EnhancedNote.new self, name: name, number: number, channel: channel, velocity: velocity

                local_notes[number] = if respond_to?(:register_note)
                                        register_note n
                                      else
                                        n
                                      end
              end

              %i{ note velocity number channel }.each do |sym|
                define_method "#{sym}!"do |&blk|
                  xform do |o|
                    puts "APPLY TO #{o}"
                    o.send("#{sym}=", instance_eval(&blk)) if EnhancedNote === o
                  end
                end
              end             
             
              private
              def events *klasses
                [ *super(*klasses), *local_notes.values.select { |o| klasses.empty? || klasses.any? { |k| k === o } } ]
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
end
