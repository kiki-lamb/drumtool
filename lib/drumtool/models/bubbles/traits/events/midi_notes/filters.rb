module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes
					  module Filters
              def self.prepended base
                base.class_eval do
                  attr_accessor :scale_notes
                  
                  bubble_attr :max_note, default: 127
                  bubble_attr :min_note, default: 0
                end
              end              

              def local_events
                puts "#{self} CALL Filters.local_events"
                super.map do |evt|
                  if self.scale_notes
                    o = evt.number
                    #puts "NOTE MUST BE IN #{self.scale_notes}"
                    until self.scale_notes.include?((evt.number % 12))
                      evt.number += 1
                    end
                    #puts "transp #{o} to #{evt.number}"
                  end
                  
                  evt                    
                end.select do |evt_|
                  n = evt_.number
                  ((! max_note) || n <= max_note) && ((! min_note) || n >= min_note)
                end
              end

              def in_scale note_name, type = :minor
#                self.scale_notes = lowest(note_name).send("#{type.to_s}_scale").note_values.map { |x| x % 12 }.tap { |ns| "SCALE: #{ns.inspect}" }
              end
              
              private
              def lowest note_name
                (Note.new(note_name.to_s)-(@__down__ = NoteInterval.new(60)))
              end
            end
          end
        end
      end
    end
  end
end
