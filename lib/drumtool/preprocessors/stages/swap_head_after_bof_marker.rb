module DrumTool
	module Preprocessors
	  module Stages
		  class StripBeforeBOFMarker < Base
		    def call
				  text.gsub /.*\nBOF\s*\n/m, ""
	      end
			end
		end
	end
end