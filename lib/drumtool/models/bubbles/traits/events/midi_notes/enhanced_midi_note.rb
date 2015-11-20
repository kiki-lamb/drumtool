module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes
				    class EnhancedMIDINote < MIDI::Note
              attr_accessor :parent

              include Traits::MethodResolutionChainedVia[:parent]

              def vel x
                self.velocity = x
              end
              
              def initialize parent, *a, **o, &b
                self.parent = parent
                super *a, **o, &b
              end
              
              def process!
                if self.action
                  case self.action.arity
                  when 0
                    self.instance_eval &action
                  else
                    self.instance_exec self, &action
                  end
                end
              end              
            end
          end
        end
      end
    end
  end
end
