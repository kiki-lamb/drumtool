module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock
          include Traits::BubbleAttrs
          include Traits::TreeOf[Track]
          include Traits::MethodResolutionChainedVia[:parent]
          include Traits::Time::Absolute
		    end
      end
		end
	end
end
