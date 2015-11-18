module DrumTool
	module Models
		class Bubbles
		  class Track < RelativeTime
				include Traits::Events
        include Traits::Track

        bubble_attr :child_type, default: Bubbles::Pattern
		  end
		end
	end
end
