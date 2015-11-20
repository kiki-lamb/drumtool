module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes

				    class EnhancedMIDINote < MIDI::Note
              include Traits::WithInitializationAttr[:parent]
              include Traits::MethodResolutionChainedVia[:parent]
              include Traits::BubbleAttrs::Attrify[:velocity, as: :vel ]
              include Traits::BubbleAttrs::Attrify[:channel,  as: :chan ]
              include Traits::BubbleAttrs::Attrify[:number,   as: :note ]

              def n
                self
              end
              
              def merge! other
                self.parent = other.parent # .tap { |x| puts "X: #{x}" }
                super
              end
              
              def process!
                # puts "#{self} => #{parent}"
                
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
