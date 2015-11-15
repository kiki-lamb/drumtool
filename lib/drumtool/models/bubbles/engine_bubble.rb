module DrumTool
	module Models
		module Bubbles
		  class EngineBubble < AbsoluteTimeBubble
		    bubble_attr :refresh_interval, default: 16
		    bubble_attr :bpm, default: 112

				# This is needed to make it a valid engine for Playbacks:
				def events_at t
				  tick t
					events.map &:last
				end				

			  def initialize *a
				  super MusicBubble, *a
				end
		  end
		end
	end
end
