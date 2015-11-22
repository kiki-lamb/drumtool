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
                self.number = x || self.number || 0
              end

              
              def chan x = nil
                self.channel = x || self.channel || 1
              end

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
                self.parent = other.parent
                self.action ||= other.action
                super
              end
              
              def process! in_parent = nil, &blk
                self.dup.tap do |copy|
                  p = blk || copy.action
                  copy.parent = in_parent if in_parent
                  
                  case p.arity
                  when 0
                    copy.instance_eval &p
                  else
                    copy.instance_exec copy, &p
                  end if p
                  
                  copy.action = nil unless blk
                  copy
                end
              end              
            end
          end
        end
      end
    end
  end
end
