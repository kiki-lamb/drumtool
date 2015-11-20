module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track
          include Traits
          
          include BubbleAttrs
          include TreeOf[ Pattern ]
          include MethodResolutionChainedThrough[ :parent ]
          include BubbleAttrs::ChainedAttrsThrough[ :parent ]
          
          include Time::Relative

				  include Events
          include Events::Sequence
		    end
      end
		end
	end
end
