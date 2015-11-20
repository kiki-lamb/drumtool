module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits::BubbleAttrs
          include Traits::Tree[Pattern]
          include Traits::ChainedMethodResolution[:parent]
          include Traits::BubbleAttrs::Chained[:parent]

          include Traits::Time::Relative
          prepend Traits::Time::Relative::EnhancedLooping

				  include Traits::Events
          include Traits::Events::Chain
			    include Traits::Events::BetterNotes
			    include Traits::Events::Triggered
          include Traits::Events::Triggered::DropAndTake
		    end
      end
		end
  end
end
