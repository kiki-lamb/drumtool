require_relative "./bubble"

class Drum
  class MusicalBubble < Bubble
	  bubble_attr :loop, default: nil

		proximal_bubble_toggle :mute
		
		bubble_attr :rotate
		bubble_attr :shift
		cumulative_bubble_attr :scale

		def time	
	    e_time = (tick * (2**(-scale))).to_f

      e_time -= e_rotate
      e_time %= loop if loop
      e_time -= e_shift
 
		  loop ? tick%loop : tick
		end

		def active? 
		  # puts "#{" "*depth}(MB) #{self}.active? #{time}"
		  ! mute?
		end

		def events force: false
		  # puts "#{" "*depth}(MB) #{self}.events #{time}, #{force ? "true" : "false"}"

		  (
			  self.children.map do |ch|
			    ch.events
			  end.flatten(1) if (force || active?)
			) || []
		end
	end
end
