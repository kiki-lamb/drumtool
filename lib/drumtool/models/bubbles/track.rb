module DrumTool
	module Models
		class Bubbles
		  class Track < RelativeTime
				include Traits::Events
        include Traits::Track

        def initialize *a, &b
          pattern_type Pattern
          super 
        end
		  end
		end
	end
end
