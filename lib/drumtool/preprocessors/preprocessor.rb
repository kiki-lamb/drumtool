module DrumTool
  module Preprocessors
    class Preprocessor < Base
        abbreviate \
          :flip,
          :instrument,
          :loop,
          :mute, 
          :refresh_interval,
          :rotate,
          :scale,
          :shift,
          :trigger,
          :untrigger

				synonymize \
          loop: :scope,
          trigger: [ :when, :on ],
          untrigger: [ :not, :except, :exclude ]

				stages \
				   :untabify,
           :strip_blank_lines_and_trailing_whitespace,
           :extend_block_comments,
           :strip_blank_lines_and_trailing_whitespace_and_comments,
           :rubify_arguments_and_expand_abbreviations,
           :rubify_pythonesque_blocks,
           :procify,
           :objectify				

		end
	end
end
