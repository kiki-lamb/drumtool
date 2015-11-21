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
		    end
      end
		end
	end
end
