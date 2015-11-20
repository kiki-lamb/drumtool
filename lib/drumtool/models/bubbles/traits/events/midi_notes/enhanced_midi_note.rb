module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes

				    class EnhancedMIDINote < MIDI::Note
#              include Traits::WithInitializationAttr[:parent]
              include Traits::MethodResolutionChainedVia[:parent]
              include Traits::BubbleAttrs::Attrify[:velocity, as: :vel ]
              include Traits::BubbleAttrs::Attrify[:channel,  as: :chan ]
              include Traits::BubbleAttrs::Attrify[:number,   as: :note ]

              attr_accessor :parent
              attr_accessor :action              

              def initialize parent, *a, &b
                self.parent = parent
                self.action = b
                super *a
              end
              
              def n
                self
              end
              
              def merge! other
                self.parent = other.parent # .tap { |x| puts "X: #{x}" }
                super
              end
              
              def process!
                puts "#{self}.action = #{action}"
                
                if self.action
                  case self.action.arity
                  when 0
                    self.dup.instance_eval &action
                  else
                    self.dup.instance_exec self, &action
                  end
                else
                  self.dup                  
                end
              end              
            end
          end
        end
      end
    end
  end
end
