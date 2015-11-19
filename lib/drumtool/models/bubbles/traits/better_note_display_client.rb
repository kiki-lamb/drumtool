module DrumTool
  module Models
		class Bubbles
      module Traits
		    module BetterNoteDisplayClient
			    def self.included base
					  base.hash_bubble_attr :notes, flip: true, permissive: true do |k, v|
              register_note v, k
            end
				  end
			  end
      end
		end
	end
end
