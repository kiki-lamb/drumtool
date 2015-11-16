module DrumTool
  module Models
		module Bubbles
		  class Pattern < RelativeTimeline
			  include Triggered
				include Events				
			  include Notes
				include LanguageHelper

				def events
					active? ? super : []
				end
				
				private				
				def local_events
				  notes_a
				end
		  end
		end
  end
end
