require "modularity"

module DrumTool
  module Models
    class Bubbles
      module Traits
        module ChainableEventsInRelativeTime
          as_trait do |child_klass|
            include Traits::RelativeTime
				    include Traits::Events
            include Traits::Events::Chain
          end
        end
      end
    end
  end
end
