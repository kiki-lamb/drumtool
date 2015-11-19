module DrumTool
  module Models
    class Bubbles
      module Standard
        class Base
          include Traits::BubbleAttrs
          include Traits::Tree
          include Traits::ChainedBubbleAttrs
          include Traits::ChainedMethodResolution

          NextMethodResponder = :parent
          NextBubbleAttrResponder = :parent
        end
      end
    end
  end
end
