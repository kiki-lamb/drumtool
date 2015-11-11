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

		def events_at time
			time %= loop if loop

		  (
			  self.children.map do |ch|
			    ch.events_at time
			  end.flatten if fires_at? time
			) || []
		end
	end
end
