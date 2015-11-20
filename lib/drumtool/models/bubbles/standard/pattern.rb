module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Track
          include Traits
          
          prepend Time::Relative::EnhancedLooping

			    include Events::MIDINotes
			    include Events::Triggered
          include Events::Triggered::DropAndTake

          prepend Events::MIDINotes::Scale
        end
      end
		end
  end
end
