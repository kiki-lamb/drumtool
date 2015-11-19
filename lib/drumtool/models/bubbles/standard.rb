module DrumTool
  module Models
    class Bubbles
		  module Standard
        def self.track &b
          Standard::Track.new(clock).build &b
        end
        
        def self.clock
          Standard::Clock.new
        end
			end
		end
  end
end
