module DrumTool
	module Preprocessors
	  module Stages
		  module Untabify 
		    def self.call pp
	        pp.text.gsub /\t/m, '  '       
	      end
			end
		end
	end
end