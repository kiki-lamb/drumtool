module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Transform
                module Rename
                  def name name_
                    xform do |note|
                      note.name = name_
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
