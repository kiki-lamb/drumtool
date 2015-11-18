module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Base
          include Traits::RelativeTime
				  include Traits::Events				
			    include Traits::Triggered
			    include Traits::Notes
          include Traits::NoteDisplayClient
          include Traits::Chain
          prepend Traits::EnhancedLooping
          include Traits::DropAndTake
		    end
      end
		end
  end
end
