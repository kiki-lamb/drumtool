module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filter
              module InScale                
                def in_scale *a
                  filter do |evt| 
                    scale_notes(*a).include? evt.number%12
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

