module DrumTool
  module Models
		class Bubbles
      module Standard
		    class Pattern < Base
          include Traits::RelativeTime
				  include Traits::Events				
			    include Traits::Triggered
			    include Traits::Notes
          include Traits::NoteDisplayClient
		    end
      end
		end
  end
end
