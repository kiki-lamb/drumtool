module DrumTool
  module Preprocessors
    class BubblePreprocessor < Preprocessor

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

				stages %i{
				   untabify
           strip_blank_lines_and_trailing_whitespace
           extend_block_comments
           strip_blank_lines_and_trailing_whitespace_and_comments
           rubify_arguments_and_expand_abbreviations
           rubify_pythonesque_blocks
           objectify			
				}

			def objectify
			  self.text = "self.class.include DrumTool::Models\nBubbles.track do \n#{text}\nend"
			end
		end
	end
end
            
						