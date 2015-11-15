module DrumTool
  module Models
		module Bubbles
		  class Pattern < Triggered
			  include Notes
				include Events				

				private				
				def local_events
				  active? ? notes_a : super()
				end
		  end
		end
  end
end
