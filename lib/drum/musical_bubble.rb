require_relative "./bubble"

class Drum
  class MusicalBubble < Bubble
	  bubble_attr :loop, default: nil

		proximal_bubble_toggle :mute
		
		cumulative_bubble_attr :rotate
		cumulative_bubble_attr :shift
		cumulative_bubble_attr :scale

		def time 
		  loop ? tick%loop : tick
		end

		def fires? 
		  # puts "#{" "*depth}(MB) #{self}.fires? #{time}"
		  ! mute?
		end

		def events force: false
		  # puts "#{" "*depth}(MB) #{self}.events #{time}, #{force ? "true" : "false"}"

		  (
			  self.children.map do |ch|
			    ch.events
			  end.flatten(1) if (force || fires?)
			) || []
		end
	end
end
