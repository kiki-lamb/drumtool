module DrumTool
	module Models
		class Bubbles
      module Standard
		    class Clock < Base
          include Traits::AbsoluteTime
          include Traits::ClockReverse
		    end
      end
		end
	end
end
