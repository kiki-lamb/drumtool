module DrumTool
	module Preprocessors
	  module Stages
		  class StripBlankLinesAndTrailingWhitespaceAndComments < Base
        def initialize *a, exclude: nil
          @exclude = exclude
          super *a
        end

        def call
          text.gsub /(?:\s*(?:##{"(?!#{@exclude})" if @exclude}[^\n]*)?\n)+/m, "\n"
	    	end
			end
		end
	end
end
