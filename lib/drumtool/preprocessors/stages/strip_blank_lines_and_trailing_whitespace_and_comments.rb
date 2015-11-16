module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
	    	def strip_blank_lines_and_trailing_whitespace_and_comments text
	    	  text.gsub /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
	    	end
			end
		end
	end
end