module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
	      def untabify text
	        text.gsub /\t/m, '  '       
	      end
			end
		end
	end
end