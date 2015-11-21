module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Transpose
                def self.prepended base
                  base.class_eval do
                    bubble_attr :semitones, default: 0
                    bubble_attr :octave, default: 0
                  end
                end
                
                def events
                  super.each do |evt|
                    evt.number += semitones
                    evt.number += octave * 12
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
