module DrumTool
  module Models
		class LighterBubbles
		  class Pattern < RelativeTime
			  include Bubbles::Triggered
				include Bubbles::Events				
			  include Bubbles::Notes
        include Bubbles::PatternBehaviour
		  end
		end
  end
end
