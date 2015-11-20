module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Track
          include Traits
          
			    include Triggered
          include Triggered::DropAndTake

          prepend Time::Relative::EnhancedLooping
          
			    prepend Events::MIDINotes
          prepend Events::MIDINotes::Filters
        end
      end
		end
  end
end
