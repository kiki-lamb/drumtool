module DrumTool
  module Models
		class Bubbles
      module Traits
		    module Events
          module NotesTable
            def register_note note
              note_registry[note.name].merge! note
            end
            
            def displayed_notes
              evts = events
              
              note_registry.map do |k, v|
                (evts.include? v.number) || (evts.include? v) ? k : nil
              end
            end
            
            def note_registry
              @__note_registry ||= Hash.new { |h,k| h[k] = Note.new }
            end
			    end
        end
		  end
	  end
  end
end

