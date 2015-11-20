require "modularity"

module DrumTool
  module Models
    class Bubbles
		  module Standard
        def track &b
          c = clock
          t = Standard::Track.new(c).build &b
          c
        end
        
        def clock
          Standard::Clock.new
        end
			end
		end
  end
end
