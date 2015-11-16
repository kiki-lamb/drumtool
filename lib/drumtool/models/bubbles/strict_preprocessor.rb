module DrumTool
  module Models
	  class Bubbles
    	class StrictPreprocessor < Preprocessors::Base		
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
      	   :objectify,
	    	   StripBlankLinesAndTrailingWhitespace

				def objectify
				  self.text = "self.class.include DrumTool::Models\nBubbles.track do \n#{text}\nend"
				end
			end
		end
	end
end
            
						