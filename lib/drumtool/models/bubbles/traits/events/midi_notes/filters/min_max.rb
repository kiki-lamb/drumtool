module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module MinMax
                def self.prepended base
                  base.class_eval do
                    bubble_attr :min_note, default: 0
                    bubble_attr :max_note, default: 127
                  end
                end

                def local_events
                  super.select do |evt_|
                    ((! max_note) || evt_.number <= max_note) && ((! min_note) || evt_.number >= min_note)
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
