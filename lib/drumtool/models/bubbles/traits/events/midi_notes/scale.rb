module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes
					  module Scale
              def self.prepended base
                base.class_eval do
                  attr_accessor :scale_notes 
                end
              end
              
              def minor note_name
                self.scale_notes = Note.new(note_name.to_s).minor_scale.note_values.map { |x| x % 12 }
              end
              
              def major note_name
                self.scale_notes = Note.new(note_name.to_s).major_scale.note_values.map { |x| x % 12 }
              end
                                                       
              def events
                super.each do |evt|
                  if MIDI::Note === evt
                    if self.scale_notes
                      evt.process!
                      evt.action = nil
                      o = evt.number

                      until self.scale_notes.include?((evt.number % 12))

                        evt.number += 1
                      end
                      evt.action = nil
#                      puts "#{o} => #{evt.number}"
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
end
