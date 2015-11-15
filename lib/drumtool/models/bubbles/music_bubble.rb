module DrumTool
  module Models
		module Bubbles
		  class MusicBubble < TriggeredBubble
			  hash_bubble_attr :notes, flip: true, permissive: true

				def to_s
				  "#{super}(#{notes.values.join ", "})"
				end

				def payload
				  notes.to_a.map &:reverse!
				end		    
		  end
		end
  end
end
