module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track
          include Traits::BubbleAttrs
          include Traits::TreeOf[Pattern]
          include Traits::MethodResolutionChainedVia[:parent]
          include Traits::BubbleAttrs::ChainedVia[:parent]

          include Traits::Time::Relative
				  include Traits::Time::Events
          include Traits::Time::Events::Chain
          include Traits::Time::Events::BetterNoteDisplay

          include Traits::Engine
		    end
      end
		end
	end
end
