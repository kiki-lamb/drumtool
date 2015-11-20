module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock
          include Traits
          
          include BubbleAttrs
          include TreeOf[Track]

          include Events         
          include Engine
          include Events::NotesDisplay
          
          include Time::Absolute
		    end
      end
		end
	end
end
