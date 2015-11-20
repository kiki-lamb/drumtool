module DrumTool
  module Models
		class Bubbles
      module Traits
        module Events
		      module MIDINotes

				    class EnhancedMIDINote < MIDI::Note
              include Traits::WithInitializationAttr[:parent]
              include Traits::MethodResolutionChainedThrough[:parent]
              include Traits::BubbleAttrs::Attrify[:velocity, as: :vel ]
              include Traits::BubbleAttrs::Attrify[:channel,  as: :chan ]
              include Traits::BubbleAttrs::Attrify[:number,   as: :note ]
              include Traits::BubbleAttrs::Attrify[:number,   as: :num ]

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
                self.parent = other.parent   # .tap { |x| puts "X: #{x}" }
                self.action ||= other.action # .tap { |x| puts "X: #{x}" }
                super
              end
              
              def process!
                self.dup.tap do |copy|              
                  case copy.action.arity
                  when 0
                    copy.instance_eval &action
                  else
                    copy.instance_exec copy, &action
                  end if copy.action
                  
                  copy.action = nil
                end
              end              
            end
          end
        end
      end
    end
  end
end
