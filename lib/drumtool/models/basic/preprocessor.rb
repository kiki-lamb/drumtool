module DrumTool
	module Models
		module Basic
    	class Preprocessor < Preprocessors::Base
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
end