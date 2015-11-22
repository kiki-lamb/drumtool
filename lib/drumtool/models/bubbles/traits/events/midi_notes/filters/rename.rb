module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Rename
                def rename new_name
                  @new_name = new_name
                end

                def events
                  return super unless @new_name
                  
                  super.each do |evt|
                    evt.name = @new_name
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
