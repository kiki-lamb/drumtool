module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              module Transform
                module Remap
                  module ToScale
                    def to_scale! note_name, *a
                      __to_scale__ root_note(note_name).value, note_name, *a
                    end
                    
                    def rescale! note_name, *a
                      __to_scale__ 0, note_name, *a
                    end
                    
                    private
                    def __to_scale__ *a
                      remap! *__map_for_scale__(*a)
                    end
                    
                    def __map_for_scale__ root, note_name, type = :minor, modsym = :-, *a
                      mod = case modsym
                            when :+
                              1
                            when :-
                              -1
                            else
                              raise ArgumentError, "Invalid mod symbol"
                            end                 
                      
                      notes = scale_notes(note_name, type, *a)
                      
                      (0+root..11+root).map do |note|
                        until notes.include?(note) || notes.include?(note+12) || notes.include?(note-12) 
                          note += mod
                        end
                        note
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
end
