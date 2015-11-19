module DrumTool
  module Models
		class Bubbles
      module Traits
		    module BetterNotes
			    def self.included base
					  base.hash_bubble_attr :notes_storage
				  end
          
          private				
				  def local_events
				    [ *notes.to_a.map(&:first), *super ]
				  end          
			  end
      end
		end
	end
end
