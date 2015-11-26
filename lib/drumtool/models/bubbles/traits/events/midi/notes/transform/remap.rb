module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
            module Transform
              module Remap
                # Relies upon Transform.
                def remap! *transfer_mappings
                  rremap! *transfer_mappings.each_with_index.map { |v, ix| v - ix }
                end
                
                def rremap! *transfer_mappings
                  raise ArgumentError, "Pass 12 arguments" unless [2, 12].include? transfer_mappings.count
                  
                  @@cache ||= {}
                  
                  xform do |evt|
                    evt.number = ( @@cache[[transfer_mappings,evt.number]] ||= evt.number + transfer_mappings[evt.number % 12] )
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
