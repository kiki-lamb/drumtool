module DrumTool
  module Models
		class Bubbles
      module Traits
		    module Notes
			    def self.included base
					  base.hash_bubble_attr :notes, flip: true, default: {}, permissive: true
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
