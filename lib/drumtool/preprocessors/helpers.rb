module DrumTool
	module Preprocessors
	  module Helpers
	    	def pad_number num, siz = 4
	        num.to_s.rjust siz, "0" 
	      end
	  end
  end
end
