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
                  super.tap do |s|
                    s.each do |evt|
                      evt.number += semitones
                      evt.number += octave * 12
                    end if s
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
