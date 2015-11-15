module DrumTool
	module Models
		module Bubbles
		  class TimeBubble < Bubble
		    bubble_attr :loop, default: nil
		    bubble_attr :rotate
		    bubble_attr :shift
		    bubble_attr :scale

		    proximal_bubble_toggle :mute    

		    def time  
		      base = (parent ? parent.time : tick) 
		      e_time = (base * (2**(-scale))).to_f
		      e_time -= rotate
		      e_time %= loop if loop
		      e_time -= shift
		      e_time
		    end

		    def active? 
		      ! mute?
		    end

		    def events force: false
		      (
		        self.children.map do |ch|
		          ch.events
		        end.flatten(1) if (force || active?)
		      ) || []
		    end
		  end
		end
	end
end