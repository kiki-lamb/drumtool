module DrumTool
	module Preprocessors
	  module Stages
		  class Splitify < Base
		    def call
          @splitter ||= Splitter.new text
          @splitter.source
	      end
			end
		end
	end
end
