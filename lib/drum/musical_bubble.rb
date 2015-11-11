require_relative "./bubble"

class Drum
  class MusicalBubble < Bubble
	  local_bubble_attr :length, default: nil

		proximal_bubble_toggle :mute
		
		cumulative_bubble_attr :rotate
		cumulative_bubble_attr :shift
		cumulative_bubble_attr :scale

		def events_at time
		  [].tap do |ary|
			  ary.push *(self.children.map do |ch|
			    ch.events_at(time)
			  end.flatten)
			end
		end


	end
end
