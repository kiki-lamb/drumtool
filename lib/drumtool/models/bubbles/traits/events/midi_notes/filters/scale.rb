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
                end
                
                def in_scale note_name, type = :minor
                  self.scale_notes = lowest(note_name).send("#{type.to_s}_scale").note_values.map { |x| x % 12 }
                end
                
                def local_events
                  tmp = super
                  
                  tmp = tmp.each do |evt|
                    evt.number += 1 until self.scale_notes.include?((evt.number % 12))
                  end if scale_notes
                  
                  return tmp if degrees.empty?
                  
                  tmp.select do |evt|                                            
                    degrees.include?(scale_notes.empty?? evt.note%12 : scale_notes.find_index(evt.note%12))
                  end
                end                
                
                private
                def degrees *a
                  (@degrees ||= []).push *a
                end
                
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

