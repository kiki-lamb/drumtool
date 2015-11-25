module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filter
              module MinMax                
                def min_note note
                  filter do |evt| 
                    evt.number >= note
                  end
                end

                def max_note note
                  filter do |evt|
                    evt.number <= note
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

