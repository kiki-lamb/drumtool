module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Name
                def self.prepended base
                  base.bubble_attr :name, default: nil
                end

                def events
                  return super unless name
                  
                  super.map(&:dup).each do |evt|
                    evt.name = name
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
