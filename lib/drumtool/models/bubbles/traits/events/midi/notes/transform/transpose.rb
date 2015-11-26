module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              module Transform
                module Transpose
                  def semitone! v
                    xform do |evt|
                      evt.number += v
                    end
                  end
                  
                  def octave! v
                    xform do |evt|
                      evt.number += v * 12
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
