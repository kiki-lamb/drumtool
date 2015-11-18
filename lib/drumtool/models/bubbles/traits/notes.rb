module DrumTool
  module Models
		class Bubbles
      module Traits
		  module Notes
			  def self.included base
					base.hash_bubble_attr :notes, flip: true, permissive: true
				end

				def to_s
				  "#{super}(#{notes.values.join ", "})"
				end

				def notes_a
				  notes.to_a.map &:first
				end		    
			end
      end
		end
	end
end