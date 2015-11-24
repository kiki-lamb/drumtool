module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Transform
                def xform &blk
                 __transform_actions__.push blk
                end

                def events
                  return super if __transform_actions__.empty?
                  
                  super.map do |evt|
                    evt.action! *__transform_actions__, in_context: self
                  end
                end

                def __transform_actions__
                  @__transform_actions__ ||= []
                end
              end
            end
          end
        end
      end
    end
  end
end
