module DrumTool
  module Models
    class Bubbles
      module Traits
        module BubbleAttrs
          module Attrify
            as_trait do |*attrs, as: nil|
              raise ArgumentError, "Pass one attr when using 'as'" unless attrs.length == 1 if as

              attrs.each do |attr|
                define_method (as || attr) do | x = nil |
                  return super() unless x
                  self.send "#{attr}=", x
                end
              end
            end
          end
        end
      end
    end
  end
end
