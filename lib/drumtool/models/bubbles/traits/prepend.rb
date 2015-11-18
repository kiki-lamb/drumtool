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
        end
      end
    end
  end
end
