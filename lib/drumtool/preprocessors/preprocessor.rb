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
         :strip_blank_lines_and_trailing_whitespace,
         :extend_block_comments,
         :strip_blank_lines_and_trailing_whitespace_and_comments,
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
