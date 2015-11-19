module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits::ChainedBubbleTree[Pattern]
          include Traits::RelativeTime
				  include Traits::Events				
			    include Traits::Triggered
			    include Traits::BetterNotes
          include Traits::Chain
          prepend Traits::EnhancedLooping
          include Traits::DropAndTake
		    end
      end
		end
  end
end
