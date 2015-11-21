module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Scale
                def self.prepended base
                  base.class_eval do
                    attr_accessor :scale_notes
                  end

                  def in_scale note_name, type = :minor
                    self.scale_notes = lowest(note_name).send("#{type.to_s}_scale").note_values.map { |x| x % 12 }
                  end
                                    
                  def local_events
                    return super unless self.scale_notes
                    
                    super.each do |evt|                  
                      o = evt.number
                      evt.number += 1 until self.scale_notes.include?((evt.number % 12))
                    end                    
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
  end
end
