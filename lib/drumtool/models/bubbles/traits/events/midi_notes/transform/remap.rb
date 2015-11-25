module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Transform
              module Remap
                # Relies upon Transform.
                def remap! *transfer_mappings
                  rremap! *transfer_mappings.each_with_index.map { |v, ix| v - ix }
                end
                
                def rremap! *transfer_mappings
                  raise ArgumentError, "Pass 12 arguments" unless [2, 12].include? transfer_mappings.count
                  
                  @@cache ||= {}
                  
                  xform do |note|
                    note.number = ( @@cache[[transfer_mappings,note.number]] ||= note.number + transfer_mappings[note.number % 12] )
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

