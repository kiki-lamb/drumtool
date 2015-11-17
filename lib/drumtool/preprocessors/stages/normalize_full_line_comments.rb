module DrumTool
	module Preprocessors
	  module Stages
		  class NormalizeFullLineComments < Base
		    def call
          text.gsub(/^(\s*)#(\s*)/) { "##{Regexp.last_match[1]}#{Regexp.last_match[2]}" }	        
	      end
			end
		end
	end
end
