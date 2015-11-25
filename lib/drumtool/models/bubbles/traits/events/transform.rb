module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module Transform
            def xform &blk
              __transform_actions__.push blk
            end
            
            def events
              return super if __transform_actions__.empty?
             
              super.map do |evt|
                perform_actions! evt.dup, *__transform_actions__.dup
              end
            end
            
            def __transform_actions__
              @__transform_actions__ ||= []
            end
            
            private
            def perform_actions! obj, *actions
              obj.parent = self if obj.respond_to?(:parent=)
              
              while (action = actions.pop)
                case action.arity
                when 0
                  obj.instance_eval &action
                else
                  obj.instance_exec obj, &action
                end
              end

              obj
            end
          end
        end
      end
    end
  end
end


