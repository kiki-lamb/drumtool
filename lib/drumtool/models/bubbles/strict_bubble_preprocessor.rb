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
      	   StripBlankLinesAndTrailingWhitespace,
      	   ExtendBlockComments,
      	   StripBlankLinesAndTrailingWhitespaceAndComments,
					 StripBetweenHEADMarkerAndBOFMarker,
					 StripBeforeBOFMarker,
					 StripAfterEOFMarker,
      	   RubifyArgumentsAndExpandAbbreviations,
      	   RubifyPythonesqueBlocks,
      	   :objectify

				def objectify
				  self.text = "self.class.include DrumTool::Models\nBubbles.track do \n#{text}\nend"
				end
			end
		end
	end
end
            
						