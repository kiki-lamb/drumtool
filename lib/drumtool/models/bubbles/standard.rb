module DrumTool
  module Models
    class Bubbles
		  module Standard
        def track &b
          Standard::Track.new(clock).build &b
        end
        
        def clock
          Standard::Clock.new
        end
			end
		end
  end
end
