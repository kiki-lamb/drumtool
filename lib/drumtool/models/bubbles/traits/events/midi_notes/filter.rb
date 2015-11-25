module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filter
              def filter &blk
                __filter_actions__.unshift blk
              end

              def __filter_actions__
                @__filter_actions__ ||= []
              end
              
              def events
                return super if __filter_actions__.empty?

                super.dup.tap do |evts|
                  __filter_actions__.each do |action|
                    evts.select! &action
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
