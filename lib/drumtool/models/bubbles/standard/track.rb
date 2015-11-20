module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track
          include Traits
          
          include BubbleAttrs
          include TreeOf[Pattern]
          include MethodResolutionChainedVia[:parent]
          include BubbleAttrs::ChainedVia[:parent]
          
          include Time::Relative

				  include Events
          include Events::Chain
		    end
      end
		end
	end
end
