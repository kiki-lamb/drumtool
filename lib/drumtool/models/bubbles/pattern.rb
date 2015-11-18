module DrumTool
  module Models
		class Bubbles
		  class Pattern < RelativeTime
			  include Traits::Triggered
				include Traits::Events				
			  include Traits::Notes
			  include Traits::Pattern
		  end
		end
  end
end
