module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track < RelativeTime
				  include Traits::Events
          include Traits::Track
          include Traits::NoteDisplay
		    end
      end
		end
	end
end
