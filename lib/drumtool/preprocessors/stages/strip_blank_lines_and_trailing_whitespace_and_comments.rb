module DrumTool
	module Preprocessors
	  module Stages
		  class StripBlankLinesAndTrailingWhitespaceAndComments < Base
	    	def call
	    	  text.gsub /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
	    	end
			end
		end
	end
end