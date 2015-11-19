module DrumTool
  module Models
		class Bubbles
      module Traits
		    module BetterNoteDisplay
			    def self.included base
					  base.hash_bubble_attr :registered_notes, default: (Hash.new { |h,k| h[k] = Array.new })
				  end
          
          def register_note n
            registered_notes[n.name] << n
          end

          def displayed_notes
            evts = events
            registered_notes.map do |k, v|
              (evts & v.map(&:number)).any?? k : nil
            end
          end         
			  end
      end
		end
	end
end
