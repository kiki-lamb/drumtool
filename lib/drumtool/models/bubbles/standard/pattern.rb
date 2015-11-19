module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits::ChainedBubbleTree[Pattern]
          include Traits::ChainableEventsInRelativeTime
			    include Traits::BetterNotes
			    include Traits::Triggered
          include Traits::DropAndTake
          prepend Traits::EnhancedLooping
		    end
      end
		end
  end
end
