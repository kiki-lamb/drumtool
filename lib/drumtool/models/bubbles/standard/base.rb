module DrumTool
  module Models
    class Bubbles
      module Standard
        class Base
          include Traits::BubbleAttrs
          include Traits::Tree

          include Traits::ChainedBubbleAttrs
          NextBubbleAttrResponder = :parent

          include Traits::ChainedMethodResolution
          NextMethodResponder = :parent
        end
      end
    end
  end
end
