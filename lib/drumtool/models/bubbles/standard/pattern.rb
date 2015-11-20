module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Track
          include Traits
          
          prepend Time::Relative::EnhancedLooping

			    include Events::Notes
			    include Events::Triggered
          include Events::Triggered::DropAndTake
		    end
      end
		end
  end
end
