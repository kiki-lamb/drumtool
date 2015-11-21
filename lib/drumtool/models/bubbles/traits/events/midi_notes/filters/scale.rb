module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Scale
                def lift!
                  @mod = 1
                end

                def drop!
                  @mod = -1
                end
                
                def in_degrees *a
                  @degrees_reject ||= true
                  @degrees = a
                end

                def to_degrees *a
                  @degrees = a
                end

                def to_scale note_name, type = :minor
                  @scale_notes = lowest(note_name).send("#{type.to_s}_scale").note_values.map { |x| x % 12 }
                end

                def in_scale note_name, type = :minor
                  @scales_reject ||= true
                  @scale_notes = lowest(note_name).send("#{type.to_s}_scale").note_values.map { |x| x % 12 }
                end

                def events
                  tmp = super

                  return unless super
                  
                  if @scale_notes
                    if @scales_reject
                      tmp.select! do |evt|
                        @scale_notes.include?((evt.number % 12))
                      end
                    else
                      tmp.each do |evt|
                        evt.number += @mod || 1 until @scale_notes.include?((evt.number % 12))
                      end
                    end
                  end
                  
                  if @degrees
                    if @degrees_reject
                      tmp.select! do |evt|                                            
                        @degrees.include?((@scale_notes.nil? || @scale_notes.empty?)? evt.note%12 : @scale_notes.find_index(evt.note%12))
                      end
                    else
                      tmp.each do |evt|
                        evt.number += @mod || 1 until @degrees.include? (@scale_notes.nil? || @scale_notes.empty?)? evt.note%12 : @scale_notes.find_index(evt.note%12)
                      end
                    end
                  end
                  
                  tmp
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

