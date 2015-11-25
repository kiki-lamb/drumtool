module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filter
              module InScale                
                def in_scale *a
                  ns = scale_notes *a

                  filter do |evt|                    
                    ns.include? evt.number%12
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

