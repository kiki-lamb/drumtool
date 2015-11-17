module DrumTool
  module Models
		class LighterBubbles
		  class Pattern < RelativeTime
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
