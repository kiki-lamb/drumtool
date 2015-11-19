module DrumTool
  module Models
    class Bubbles
      module Standard
        class Base
          include  Traits::BubbleAttrs
          include Traits::ChainedMethodResolution
          include Traits::Tree
          include  Traits::ChainedBubbleAttrs

          def initialize(*)            
            next_method_responder :parent
            next_bubble_attr_responder :parent
            super
          end
        end
      end
    end
  end
end
