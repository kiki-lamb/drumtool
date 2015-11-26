module DrumTool
  module Models
    class Bubbles
      module Standard
        class Track
          include Traits
          include BubbleAttrs          
          include TreeOf[ Pattern ]
          include MethodResolution::ChainedThrough[ :parent ]
          include BubbleAttrs::ChainedAttrsThrough[ :parent ]
          include Time::Relative[ 6 ]          
          include Events
        end
      end
    end
  end
end
