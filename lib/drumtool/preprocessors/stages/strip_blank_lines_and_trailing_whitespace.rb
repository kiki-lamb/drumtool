module DrumTool
	module Preprocessors
	  module Stages
		  class StripBlankLinesAndTrailingWhitespace < Base
	    	def call
	    	  text.gsub /(?:\s*\n)+/m, "\n"
	    	end
			end
		end
	end
end