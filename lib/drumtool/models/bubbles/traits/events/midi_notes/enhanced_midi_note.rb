module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            class EnhancedMIDINote < MIDI::Note
              include Traits::MethodResolutionChainedThrough[:parent]

              def vel x = nil
                self.velocity = x || self.velocity || 100
              end

              def note x = nil
                self.note =  x || self.number || 0 
              end

              
              def chan x = nil
                self.channel = x || self.channel || 1
              end

              attr_accessor :parent

              def initialize parent, *a
                self.parent = parent
                super *a
              end
              
              def n
                self
              end
              
              def merge! other
                self.parent = other.parent
                super
              end
              
              def process! in_parent = nil, actions = []
                return self if actions.empty?
                
                self.dup.tap do |copy|
                  copy.parent = in_parent if in_parent
                  
                  actions.each do |p|                    
                    case p.arity
                    when 0
                      copy.instance_eval &p
                    else
                      copy.instance_exec copy, &p
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
end
