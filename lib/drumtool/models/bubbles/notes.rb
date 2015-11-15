module DrumTool
  module Models
		module Bubbles
		  module Notes
			  def self.included base
					base.hash_bubble_attr :notes, flip: true, permissive: true
				end

				def to_s
				  "#{super}(#{notes.values.join ", "})"
				end

				def notes_a
				  notes.to_a.map &:reverse!
				end		    
			end
		end
	end
end
