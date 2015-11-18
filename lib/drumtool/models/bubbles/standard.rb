module DrumTool
  module Models
    class Bubbles
		  module Standard
        def self.track &b
          Standard::Track.new timeline, &b
        end
        
        def self.timeline &b
          Standard::AbsoluteTime.new &b
        end
			end
		end
  end
end
