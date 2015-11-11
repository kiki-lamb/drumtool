require_relative "./bubble"

class Drum
  class MusicalBubble < Bubble
	  local_bubble_attr :loop, default: nil

		proximal_bubble_toggle :mute
		
		cumulative_bubble_attr :rotate
		cumulative_bubble_attr :shift
		cumulative_bubble_attr :scale

		def fires_at? time
		  ! mute?
		end
	end
end
