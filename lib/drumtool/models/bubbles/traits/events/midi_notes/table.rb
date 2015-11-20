module DrumTool
  module Models
		class Bubbles
      module Traits
		    module Events
          module MIDINotes
            module Table
              def register_note note
                note_registry[note.name].merge!(note)#.tap { |n| puts "N: #{n.inspect}" })
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

            def filter note
              o = note.number
              @scale ||= (Note.new("E")-NoteInterval.new(60)).minor_scale.note_values

              if note.number >= 50               
                until @scale.include?(note.number % 12)
                  note.number += 1
                  note.number %= 127
                end
              end
            end
            
            def events
              super.each do |evt|
                if MIDI::Note === evt
                  evt.merge! lookup(evt) # .tap { |x| puts "#{evt.inspect} MERGE WITH #{x.inspect}" }
                  
                  filter evt if evt.number >= 50
                end                                         
              end
            end
            
            def displayed_notes
              evts = events
              evts_names = events.map &:name
              evts_nums = events.map &:number
              
              note_registry.map do |k, v|
                evts_names.include?(v.name) || evts_nums.include?(v.number) ? k : nil
                evts_names.include?(v.name) ? k : nil
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
