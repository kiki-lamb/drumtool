module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
              module Transform
              module Remap
                # Relies upon Transform.

                def remap! *a
                  __remap__! false, a 
                end
                
                def rremap! *a
                  __remap__! true, a
                end

                private 
                def __remap__! relative, transfer_mappings
                  raise ArgumentError, "Pass 12 arguments" unless [2, 12].include? transfer_mappings.count
                  
                  @@cache ||= {}
                  
                  xform do |note|
                    note.number = ( @@cache[[transfer_mappings,note.number]] ||= __remap_note__!(note, transfer_mappings, relative) )
                  end
                end

                def __remap_note__! note, transfer_mappings, relative
                  pitch_class = note.number % 12
                  if relative
                    note.number + transfer_mappings[pitch_class]
                  else
                    note.number-pitch_class + transfer_mappings[pitch_class]
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

