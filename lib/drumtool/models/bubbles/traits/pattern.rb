module DrumTool
  module Models
		class Bubbles
      module Traits
		  module Pattern
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
end
