module DrumTool
	module Models
		class Bubbles
      module Traits
		  module Track
				def self.included base
		      base.bubble_attr :refresh_interval, default: 16
		      base.bubble_attr :bpm, default: 112
          base.bubble_attr :child_type, default: Bubbles::Standard::Pattern
        end

				# This is needed to make it a valid engine for Playbacks:
				def events_at t
				  parent.time t
					events
				end				
		  end
      end
		end
	end
end
