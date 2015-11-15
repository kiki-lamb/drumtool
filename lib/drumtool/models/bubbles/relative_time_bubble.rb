module DrumTool
	module Models
		module Bubbles
		  class RelativeTimeBubble < Bubble
		    bubble_attr :refresh_interval, default: 16
		    bubble_attr :bpm, default: 112
		    bubble_attr :loop, default: nil
		    bubble_attr :rotate
		    bubble_attr :shift
		    bubble_attr :scale
				proximal_bubble_toggle :mute

		    def time  
		      base = (parent ? parent.time : top.tick) 
		      e_time = (base * (2**(-scale))).to_f
		      e_time -= rotate
		      e_time %= loop if loop
		      e_time -= shift
		      e_time
		    end

				# This is needed to make it a valid engine for Playbacks:
				def events_at t
				  top.tick t
					events.map &:last
				end				

		    def events force: false
		      (
		        self.children.map do |ch|
		          ch.events
		        end.flatten(1)
		      ) || []
		    end
		  end
		end
	end
end
