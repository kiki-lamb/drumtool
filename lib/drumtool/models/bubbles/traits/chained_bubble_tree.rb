require "modularity"

module DrumTool
  module Models
    class Bubbles
      module Traits
        module ChainedBubbleTree
          as_trait do |child_klass|
            include Traits::BubbleAttrs
            include Traits::Tree[child_klass]
            include Traits::BubbleAttrs::Chained[:parent]
            include Traits::ChainedMethodResolution[:parent]
          end
        end
      end
    end
  end
end
