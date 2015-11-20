module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits::ChainedBubbleTree[Pattern]
          include Traits::ChainableEventsInRelativeTime
			    include Traits::Events::BetterNotes
			    include Traits::Events::Triggered
          include Traits::Events::Triggered::DropAndTake
          prepend Traits::RelativeTime::EnhancedLooping
		    end
      end
		end
  end
end
