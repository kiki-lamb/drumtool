module DrumTool
  module Models
		class Bubbles
      module Traits
		    module Events
          module MIDINotes
            module Table
              def register_note note
                note_registry[note.name].merge!(note) # .tap { |d| puts "DUP: #{d}" }
              end

            def lookup note
              if note_registry.include? note.name
                note_registry[note.name]
              elsif (n = note_registry.find do |reg_note|
                       reg_note.number == note.number
                     end)
                n
              elsif note.name || note.number
                register_note note
              end
            end
            
            def events
              super.each do |evt|
                if MIDI::Note === evt
                  evt.merge! lookup(evt) # .tap { |x| puts "#{evt.inspect} MERGE WITH #{x.inspect}" }
                end                                         
              end
            end
            
            def displayed_notes
              evts = events
              evts_names = events.map &:name
              evts_nums = events.map &:number
              
              note_registry.map do |k, v|
                evts_names.include?(v.name) || evts_nums.include?(v.number) ? k : nil
              end
            end
            
            def note_registry
              @__note_registry ||= Hash.new { |h,k| h[k] = MIDINotes::EnhancedMIDINote.new }
            end
			    end
        end
		  end
	  end
  end
end

end
