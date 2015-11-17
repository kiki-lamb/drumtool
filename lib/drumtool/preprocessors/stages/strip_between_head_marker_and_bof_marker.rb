module DrumTool
	module Preprocessors
	  module Stages
		  class StripBetweenHEADMarkerAndBOFMarker < Base
		    def call
				  text.gsub(/(.*)(?<=\n)#HEAD\s*\n(?:(.*)(?<=\n)#BOF\s*\n)?/m) { "#{Regexp.last_match[1]}" }
	      end
			end
		end
	end
end
