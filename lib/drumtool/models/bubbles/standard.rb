require "modularity"

module DrumTool
  module Models
    class Bubbles
		  module Standard
        include Traits          

        def track &b
          c = clock
          t = c.child
          t.build &b
          c
        end
        
        def clock
          Engine.new
        end
			end
		end
  end
end
