module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		    module BetterNotes
          def note name, number = nil, velocity = nil, channel = nil
            local_notes[name] = register_note name, number, velocity, channel
          end

          def notes
            local_notes.values.to_a
          end
          
          private				
				  def local_events
				    [ *local_notes.values.map(&:number), *super ]  # .tap { |x| puts "#{self} yields #{x.inspect}" }
				  end

          def local_notes
            @__local_notes ||= {}
          end
			  end
        end
      end
		end
	end
end

