module DrumTool
	module Models
		class Bubbles
		  class Track < RelativeTime
				include Events
        include TrackBehaviour
		  end
		end
	end
end
