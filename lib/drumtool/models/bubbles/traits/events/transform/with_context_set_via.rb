module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module Transform
            module WithContextSetVia
              as_trait do |attr|
                define_method :perform_actions! do |obj, *actions|
                  obj.send attr, self
                  super obj, *actions
                end
              end
            end
          end
        end
      end
    end
  end
end
