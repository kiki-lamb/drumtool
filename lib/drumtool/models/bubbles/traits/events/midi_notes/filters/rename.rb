module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Rename
                def self.prepended base
                  base.bubble_attr :rename
                end

                def events
                  return super unless rename
                  
                  super.each do |evt|
                    evt.name = rename
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
