module DrumTool
  module Models
		module Bubbles
		  class Pattern < RelativeTimeline
			  include Triggered
				include Events				
			  include Notes

				private				
				def local_events
				  active? ? notes_a : super()
				end
		  end
		end
  end
end
