module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits::BubbleAttrs
          include Traits::Tree[Pattern]
          include Traits::ChainedBubbleAttrs[:parent]
          include Traits::ChainedMethodResolution[:parent]          
          include Traits::RelativeTime
				  include Traits::Events				
			    include Traits::Triggered
			    include Traits::BetterNotes
          include Traits::Chain
          prepend Traits::EnhancedLooping
          include Traits::DropAndTake

#          def initialize(*)
#            next_responder :parent
 #           super
 #         end
		    end
      end
		end
  end
end
