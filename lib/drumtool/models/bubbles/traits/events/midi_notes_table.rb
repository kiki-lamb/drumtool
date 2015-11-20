module DrumTool
  module Models
		class Bubbles
      module Traits
		    module Events
          module MIDINotesTable
            def register_note note
              note_registry[note.name].merge! note
            end

            def events
              super.each do |evt|
                evt.merge! note_registry[evt.name] if MIDI::Note === evt && note_registry.include?(evt.name)
              end
            end
            
            def displayed_notes
              evts = events
              
              note_registry.map do |k, v|
                (evts.include? v.number) || (evts.include? v) ? k : nil
              end
            end
            
            def note_registry
              @__note_registry ||= Hash.new { |h,k| h[k] = MIDI::Note.new }
            end
			    end
        end
		  end
	  end
  end
end

