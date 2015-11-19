module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock < Base
          include Traits::BubbleAttrs
          include Traits::Tree[Pattern]
          include Traits::ChainedBubbleAttrs[:parent]
          include Traits::ChainedMethodResolution[:parent]          
          include Traits::AbsoluteTime
		    end
      end
		end
	end
end
