module DrumTool
  module Models
		class Bubbles
		  class Pattern < RelativeTime
			  include Triggered
				include Events				
			  include Notes
			  include PatternBehaviour
		  end
		end
  end
end
