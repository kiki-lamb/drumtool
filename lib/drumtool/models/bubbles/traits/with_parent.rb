module DrumTool
  module Models
    class Bubbles
      module Traits
        module WithParent
          as_trait do |attr_name|
            attr_accessor attr_name

            define_method :initialize do |parent = nil, *a|
              self.send "#{attr_name}=", parent
              super *a
            end              
          end
        end
      end
    end
  end
end
