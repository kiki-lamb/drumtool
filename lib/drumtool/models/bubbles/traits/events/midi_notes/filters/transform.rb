module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Transform
                def self.prepended base
                  base.class_eval do
                    attr_accessor :transform_action
                  end
                end
                
                def xform &blk
                  self.transform_action = blk
                end

                def local_events
                  return super unless self.transform_action
                  
                  super.map! do |evt|
                    evt.process! self, &self.transform_action
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
