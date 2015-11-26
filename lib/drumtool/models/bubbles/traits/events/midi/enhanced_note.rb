module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            class EnhancedNote < DrumTool::MIDI::Note
              include Traits::MethodResolution::ChainedThrough[:parent]

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
            end
          end
        end
      end
    end
  end
end
