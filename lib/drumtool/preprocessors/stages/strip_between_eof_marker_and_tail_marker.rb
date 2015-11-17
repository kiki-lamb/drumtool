module DrumTool
	module Preprocessors
	  module Stages
		  class StripBetweenEOFMarkerAndTAILMarker < Base
		    def call
				  text.gsub /(?<=\n)#EOF\s*\n.*(?<=\n)#TAIL\s*\n/m, ""
	      end
			end
		end
	end
end
