module DrumTool
	module Models
		class Bubbles
		  module TrackBehaviour
				def self.included base
		      base.bubble_attr :refresh_interval, default: 16
		      base.bubble_attr :bpm, default: 112
				end

				# This is needed to make it a valid engine for Playbacks:
				def events_at t
				  parent.time t
					events
				end				

       def bubble *a, &b
			 		o = Pattern.new(self, *a)
					# puts "Track: #{self} builds child #{o}"
		      o.build(&b)
		    end
		  end
		end
	end
end
