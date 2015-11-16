module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
	    	def strip_blank_lines_and_trailing_whitespace text
	    	  text.gsub /(?:\s*\n)+/m, "\n"
	    	end
			end
		end
	end
end