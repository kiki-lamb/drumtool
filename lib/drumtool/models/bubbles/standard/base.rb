module DrumTool
  module Models
    class Bubbles
      module Standard
        class Base
          extend  Traits::Klass
          include Traits::Tree
          include Traits::MethodResolutionCascading

          def initialize(*a)
#            puts "#{self} BASE INITIALIZE(#{a.inspect})"
            super(*a)
            next_responder :parent

          end
        end
      end
    end
  end
end
