module DrumTool
  module Models
		class Bubbles
      module Traits
		    module BetterNoteDisplay
          def register_note name, number = nil, velocity = nil, channel = nil
            note_registry[name].merge! Note.new(name: name, number: number, channel: channel, velocity: velocity).tap { |x| puts x.inspect }
          end

          def displayed_notes
            evts = events
            
            note_registry.map do |k, v|
              (evts.include? v.number)? k : nil
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
