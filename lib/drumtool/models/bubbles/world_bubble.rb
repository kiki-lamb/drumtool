module DrumTool
	module Models
		module Bubbles
		  class WorldBubble < MusicalBubble
		    bubble_attr :refresh_interval, default: 16
		    bubble_attr :bpm, default: 112
		    counter_bubble_attr :tick, return_value: :events, before: :play
		    
		    def initialize *a, &b
		      super *a, &b
		    end

		    def bubble &b
		      ChildBubble.new(self).build(&b)
		    end

				# This is needed to make WorldBubble a valid engine for Playbacks:
				def events_at t
				  tick t
					events.map(&:last).tap { |x| puts "OUT => #{x}" }
				end				
		  end
		end
	end
end