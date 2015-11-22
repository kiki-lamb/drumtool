module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Rename
                def self.prepended base
                  base.bubble_attr :rename, default: nil
                end

                def events
                  return super unless rename
                  
                  super.map(&:dup).each do |evt|
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
