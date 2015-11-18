module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < RelativeTime
			    include Traits::Triggered
				  include Traits::Events				
			    include Traits::Notes
          include Traits::NoteDictionaryUser
			    include Traits::Pattern
		    end
      end
		end
  end
end
