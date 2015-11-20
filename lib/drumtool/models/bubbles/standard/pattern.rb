module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits::BubbleAttrs
          include Traits::TreeOf[Pattern]
          include Traits::MethodResolutionChainedVia[:parent]
          include Traits::BubbleAttrs::ChainedVia[:parent]

          include Traits::Time::Relative
          prepend Traits::Time::Relative::EnhancedLooping
				  include Traits::Time::Events
          include Traits::Time::Events::Chain
			    include Traits::Time::Events::BetterNotes
			    include Traits::Time::Events::Triggered
          include Traits::Time::Events::Triggered::DropAndTake
		    end
      end
		end
  end
end
