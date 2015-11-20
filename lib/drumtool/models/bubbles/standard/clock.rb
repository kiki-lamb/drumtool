module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Engine
          include Traits
          
          include BubbleAttrs
          include TreeOf[Track]

          include PlaybackInterface
          
          include Time::Absolute
		    end
      end
		end
	end
end
