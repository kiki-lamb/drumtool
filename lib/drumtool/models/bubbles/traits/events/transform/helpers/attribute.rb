module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module Transform
						module Helpers
              module Attribute
                as_trait do |klass, attr, as = "#{attr}!"|
                  define_method as do |&blk|
                    xform do |o|
                      o.send("#{attr}=", instance_eval(&blk)) if klass === o
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
