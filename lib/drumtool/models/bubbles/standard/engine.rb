module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Engine
          include Traits
          
          include BubbleAttrs
          include TreeOf[ Track ]

          include Time::Absolute

          prepend PlaybackInterface          
		    end
      end
		end
	end
end
