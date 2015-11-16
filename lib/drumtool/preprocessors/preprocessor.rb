module DrumTool
  module Preprocessors
    class Preprocessor < Base
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
        loop: :scope,
        trigger: [ :when, :on ],
        untrigger: [ :not, :except, :exclude ]

			stages \
				 Untabify,
         StripBlankLinesAndTrailingWhitespace,
         ExtendBlockComments,
         StripBlankLinesAndTrailingWhitespaceAndComments,
         RubifyArgumentsAndExpandAbbreviations,
         RubifyPythonesqueBlocks,
         Procify,
         :objectify

      def objectify
        self.text =  "Models::Basic.build(&#{text})"
      end
		end
	end
end
