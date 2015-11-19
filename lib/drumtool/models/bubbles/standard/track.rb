module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track
          include Traits::ChainedBubbleTree[Pattern]
          include Traits::ChainableEventsInRelativeTime
          include Traits::BetterNoteDisplay
          include Traits::Engine
		    end
      end
		end
	end
end
