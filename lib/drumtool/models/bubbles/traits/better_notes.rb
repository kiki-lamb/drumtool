module DrumTool
  module Models
		class Bubbles
      module Traits
		    module BetterNotes

          def note name, number = nil, channel: nil, velocity: nil, open: false
            n = Note.new name: name, number: number, channel: channel, velocity: velocity, open: false
            register_note n
            storage[name] = n 
          end

          def notes
            (@notes_storage_hash ||= {}).values.to_a
          end
          
          private				
				  def local_events
				    [ *storage.values.map(&:number), *super ]
				  end

          def storage
            (@notes_storage_hash ||= {})
          end
			  end
      end
		end
	end
end
