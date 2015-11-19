require "modularity"

module DrumTool
  module Models
    class Bubbles
      module Standard
        class Base
          include Traits::BubbleAttrs
          include Traits::Tree
          include Traits::ChainedBubbleAttrs[:parent]
          include Traits::ChainedMethodResolution[:parent]
        end
      end
    end
  end
end
