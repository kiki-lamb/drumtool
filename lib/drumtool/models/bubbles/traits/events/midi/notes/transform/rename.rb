module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              module Transform
                module Rename
                  def name! name_
                    xform do |evt|
                      evt.name = name_
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
