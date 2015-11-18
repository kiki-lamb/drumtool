module DrumTool
  module Models
		class Bubbles
      module Traits
		    module NoteDisplay
			    def self.included base
					  base.hash_bubble_attr :note_names, default: (Hash.new { |h,k| h[k] = Array.new })
				  end
          
          def register_note name, number
            note_names[name] << number
          end

          def displayed_notes
            evts = events
            note_names.map do |k, v|
              (evts & v).any?? k : nil
            end
          end         
			  end
      end
		end
	end
end
