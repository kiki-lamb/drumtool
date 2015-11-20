module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		    module Notes
          def note name, number = nil, velocity = nil, channel = nil
            n = Note.new name: name, number: number, channel: channel, velocity: velocity
            local_notes[name] = if respond_to?(:register_note)
                                  register_note n 
                                else
                                  n
                                end
          end

          def notes
            local_notes.values
          end
          
          private				
				  def local_events
				    [ *notes, *super ]  # .tap { |x| puts "#{self} yields #{x.inspect}" }
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

