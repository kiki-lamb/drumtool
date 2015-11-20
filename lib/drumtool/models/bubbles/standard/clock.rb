module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock
          include Traits
          
          include BubbleAttrs
          include TreeOf[Track]
          include MethodResolutionChainedVia[:parent]

          include Time::Absolute
		    end
      end
		end
	end
end
