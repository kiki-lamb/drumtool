module DrumTool
	module Preprocessors
	  module Stages
		  class StripAfterEOFMarker < Base
		    def call
				  text.gsub /\n#EOF\s*\n.*/m, ""
	      end
			end
		end
	end
end
