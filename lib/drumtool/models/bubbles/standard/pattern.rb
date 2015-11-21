module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Track
          include Traits

          prepend Time::Relative::EnhancedLooping

          prepend Events::MIDINotes
			    prepend Events::Triggered
          prepend Events::MIDINotes::Filters
        end
      end
		end
  end
end
