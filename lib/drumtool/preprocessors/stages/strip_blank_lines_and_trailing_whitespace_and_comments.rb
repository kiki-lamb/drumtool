module DrumTool
	module Preprocessors
	  module Stages
		  class StripBlankLinesAndTrailingWhitespaceAndComments < Base
        def initialize p = nil, exclude: nil
          @exclude = exclude
          super p
        end

        def call
	    	  #text.gsub /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
          text.gsub /(?:\s*(?:##{"(?!#{@exclude})" if @exclude}[^\n]*)?\n)+/m, "\n"
	    	end
			end
		end
	end
end
