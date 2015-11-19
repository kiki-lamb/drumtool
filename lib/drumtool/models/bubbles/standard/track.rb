module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Track < Base
          include Traits::RelativeTime
				  include Traits::Events
          include Traits::Engine
          include Traits::NoteDisplay
          include Traits::Chain
          
          bubble_attr :child_type, default: Bubbles::Standard::Pattern
		    end
      end
		end
	end
end
