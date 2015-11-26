module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            class EnhancedController < DrumTool::MIDI::Controller
              include Traits::MethodResolution::ChainedThrough[:parent]

              def num x = nil
                self.cc = cc || self.cc || 0
              end

              def val x = nil
                self.value = value || self.value || 0
              end
              
              def chan x = nil
                self.channel = x || self.channel || 1
              end

              def n
                self
              end

              attr_accessor :parent

              def initialize parent, *a
                self.parent = parent
                super *a
              end
              
            end
          end
        end
      end
    end
  end
end
