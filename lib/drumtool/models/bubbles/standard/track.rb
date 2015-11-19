module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track
          include Traits::ChainedBubbleTree[Pattern]
          include Traits::RelativeTime
				  include Traits::Events
          include Traits::Engine
          include Traits::BetterNoteDisplay
          include Traits::Chain          
		    end
      end
		end
	end
end
