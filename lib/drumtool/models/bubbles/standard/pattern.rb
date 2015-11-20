module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Track
          include Traits
          
          prepend RelativeTime::EnhancedLooping

			    include Events::Notes
			    include Events::Triggered
          include Events::Triggered::DropAndTake
		    end
      end
		end
  end
end
