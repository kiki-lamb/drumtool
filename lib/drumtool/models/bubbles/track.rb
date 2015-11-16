module DrumTool
	module Models
		class Bubbles
		  class Track < RelativeTime
				include Events
				include LanguageHelper

		    bubble_attr :refresh_interval, default: 16
		    bubble_attr :bpm, default: 112

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
