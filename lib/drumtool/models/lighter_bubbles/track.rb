module DrumTool
	module Models
		class LighterBubbles
		  class Track < RelativeTime
				include Bubbles::Events
        include Bubbles::TrackBehaviour
		  end
		end
	end
end
