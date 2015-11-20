module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes

				    class EnhancedMIDINote < MIDI::Note
              class << self
              end
              
              include Traits::WithParent[:parent]
              include Traits::MethodResolutionChainedVia[:parent]
              include Traits::BubbleAttrs::Attrify[:velocity, as: :vel ]
              include Traits::BubbleAttrs::Attrify[:channel,  as: :chan ]
              include Traits::BubbleAttrs::Attrify[:number,   as: :num ]

              def process!
                puts "#{self} => #{parent}"
                
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
