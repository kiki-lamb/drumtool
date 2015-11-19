module DrumTool
  module Models
		class Bubbles
      module Traits
		    module BetterNotes
          def note name, number = nil, velocity = nil, channel = nil
            puts "`#{name}' `#{number}'"
            local_notes[name] = register_note(name, number, velocity, channel).tap { |x| puts "T: #{x.inspect}" }
          end

          def notes
            local_notes.values.to_a
          end
          
          private				
				  def local_events
				    [ *local_notes.values.map(&:number), *super ]
				  end

          def local_notes
            @__local_notes ||= {}
          end
			  end
      end
		end
	end
end
