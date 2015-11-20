module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock
          include Traits::BubbleAttrs
          include Traits::Tree[Track]
          include Traits::ChainedMethodResolution[:parent]
          include Traits::BubbleAttrs::Chained[:parent]

          include Traits::Time::Absolute
		    end
      end
		end
	end
end
