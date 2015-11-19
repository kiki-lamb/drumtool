module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track
          include Traits::BubbleAttrs
          include Traits::Tree[Pattern]
          include Traits::ChainedBubbleAttrs[:parent]
          include Traits::ChainedMethodResolution[:parent]          
          include Traits::RelativeTime
				  include Traits::Events
          include Traits::Engine
          include Traits::BetterNoteDisplay
          include Traits::Chain
          
          bubble_attr :child_type, default: Bubbles::Standard::Pattern
		    end
      end
		end
	end
end
