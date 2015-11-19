module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock
          include Traits::ChainedBubbleTree[Track]
          include Traits::AbsoluteTime
		    end
      end
		end
	end
end
