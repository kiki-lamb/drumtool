module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Track
          include Traits
          include Traits::Events
          
          prepend Time::Relative::EnhancedLooping

			    include Triggered
          include Triggered::DropAndTake
          
			    prepend MIDINotes
          prepend MIDINotes::Filters
        end
      end
		end
  end
end
