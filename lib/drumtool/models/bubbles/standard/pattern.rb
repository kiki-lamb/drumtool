module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits
          
          include BubbleAttrs
          include TreeOf[Pattern]
          include MethodResolutionChainedVia[:parent]
          include BubbleAttrs::ChainedVia[:parent]
         
          include Time::Relative
          prepend Time::Relative::EnhancedLooping

				  include Events
          include Events::Chain
			    include Events::Notes
			    include Events::Triggered
          include Events::Triggered::DropAndTake
		    end
      end
		end
  end
end
