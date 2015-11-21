module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern
          include Traits

          include BubbleAttrs
          
          include TreeOf[ Pattern ]
          include MethodResolutionChainedThrough[ :parent ]
          include BubbleAttrs::ChainedAttrsThrough[ :parent ]
          
          include Time::Relative
          prepend Time::Relative::EnhancedLooping
          
				  include Events
          prepend Events::MIDINotes::Filters
			    prepend Events::Triggered
			    prepend Events::MIDINotes

        end
      end
		end
  end
end
