module DrumTool
  module Models
    class Bubbles
      module Traits
        module Instance        
          def method_missing name, *a, &b
            if parent.respond_to?(name)
              parent.send name, *a, &b
            else
              super
            end
          end
          
          def respond_to? name, all = false
            super(name, all) || (parent && parent.respond_to?(name, all))
          end
        end
      end
    end
  end
end
