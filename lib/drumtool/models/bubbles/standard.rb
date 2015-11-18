module DrumTool
  module Models
    class Bubbles
		  module Standard
        def self.track &b
          Standard::Track.new(timeline).build &b
        end
        
        def self.timeline
          Standard::AbsoluteTime.new
        end
			end
		end
  end
end
