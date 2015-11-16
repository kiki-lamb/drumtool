module DrumTool
  module Models
	  class Bubbles
		  module Preprocessors
    		class StrictPreprocessor < DrumTool::Preprocessors::Base		
				  include Stages

      		abbreviate %i{
      		  bubble
      		  flip
      		  instrument
      		  loop
      		  mute!
      		  note
      		  refresh_interval
      		  rotate
      		  scale
      		  shift
						trigger
						untrigge
					}

					synonymize \
      		  bubble: [:pattern, :part, :scope],
      		  trigger: [ :when, :on ],
      		  untrigger: [ :not, :except, :exclude ]

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
	    		   StripBlankLinesAndTrailingWhitespace,
						 ObjectifyAsBubble
				end
			end
		end
	end
end
