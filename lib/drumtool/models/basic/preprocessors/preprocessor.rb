module DrumTool
	module Models
		module Basic
		  module Preprocessors
    		class Preprocessor < DrumTool::Preprocessors::Base
				  include Stages

    		  abbreviate %i{
    		    flip
    		    instrument
    		    loop
    		    mute
    		    refresh_interval
    		    rotate
    		    scale
    		    shift
    		    trigger
    		    untrigger
					}

					synonymize \
    		    loop: [ :pattern, :part, :scope, :bubble ],
    		    trigger: [ :when, :on ],
    		    untrigger: [ :not, :except, :exclude ],
						instrument: :note

					stages \
						 Untabify,
      		   StripBlankLinesAndTrailingWhitespaceAndComments,
						 StripBetweenHEADMarkerAndBOFMarker,
						 StripBeforeBOFMarker,
						 StripBetweenEOFMarkerAndTAILMarker,
						 StripAfterEOFMarker,
    		     ExtendBlockComments,
    		     StripBlankLinesAndTrailingWhitespaceAndComments,
    		     RubifyArgumentsAndExpandAbbreviations,
    		     RubifyPythonesqueBlocks,
    		     Procify,
						 Objectify
				end
			end
		end
	end
end