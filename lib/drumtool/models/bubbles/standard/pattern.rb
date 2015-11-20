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
