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
                puts "#{self.inspect} ACTION IS #{b}"
              end
              
              def n
                self
              end
              
              def merge! other
                self.parent = other.parent   # .tap { |x| puts "X: #{x}" }
                self.action ||= other.action # .tap { |x| puts "X: #{x}" }
                super
              end
              
              def process!
                puts "#{self.inspect}.action = #{action}"
                copy = self.dup
                
                if self.action
                  case self.action.arity
                  when 0
                    copy.instance_eval &action
                  else
                    copy.instance_exec self, &action
                  end
                else
                  copy                  
                end

                copy.action = nil
                
                copy
              end              
            end
          end
        end
      end
    end
  end
end
