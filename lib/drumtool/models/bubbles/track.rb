module DrumTool
	module Models
		class Bubbles
		  class Track < RelativeTime
				include Traits::Events
        include Traits::Track
		  end
		end
	end
end
