module DrumTool
	module Models
		module Bubbles
		  class EventBubble < Bubble
				proximal_bubble_toggle :mute

		    def events force: false
		      (
		        self.children.map do |ch|
		          ch.events
		        end.flatten(1) unless mute?
		      ) || []
		    end
		  end
		end
	end
end
