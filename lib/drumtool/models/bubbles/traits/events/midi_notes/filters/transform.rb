module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Transform
                def xform &blk
                 __transform_actions__.unshift blk
                end

                def events
                  return super if __transform_actions__.empty?
                  
                  super.map do |evt|
                    evt.process! self, __transform_actions__
                  end
                end

                private
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
