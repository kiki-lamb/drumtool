module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDI
            module Notes
              module Transform
                module Attributes
                  %i{ note velocity number channel }.each do |sym|
                    define_method "#{sym}!"do |&blk|
                      xform do |o|
                        o.send("#{sym}=", instance_eval(&blk)) if EnhancedNote === o
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
end
