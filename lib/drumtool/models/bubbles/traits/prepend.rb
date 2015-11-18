module DrumTool
  module Models
    class Bubbles
      module Traits
        module Prepend
          def prepend_bubble *a, &b
            parent.children.delete self
            ancestor = (child_type || self.class).new(parent, *a)
            ancestor.children << self
            @parent = ancestor
            ancestor.build &b
          end

          def append_bubble *a, &b
            descendant = (child_type || self.class).new(nil, *a)
            descendant.children.unshift *children
            children.clear
            descendant.instance_eval do
              @parent = self
            end
            descendant.build &b
          end
        end
      end
    end
  end
end
