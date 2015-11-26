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
                    xform do |note|
                      note.number += v
                    end
                  end
                  
                  def octave! v
                    xform do |note|
                      note.number += v * 12
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
