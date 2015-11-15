module DrumTool
    module Preprocessors
        class BubblePreprocessor < Preprocessor
				  class << self
	        def abbreviations
					  @abbreviations ||= {
	          	"refr" => "refresh_interval",
	          	"ref" => "refresh_interval",

	          	"no" => "untrigger",
	          	"not" => "untrigger",
	          	"ex" => "untrigger",
	          	"exc" => "untrigger",
	          	"except" => "untrigger",
	          	"excl" => "untrigger",
	          	"exclude" => "untrigger",

	          	"sc" => "scale",
	          	"sca" => "scale",
	          	"scl" => "scale",

	          	"rep" => "repeat",
	          	"rp" => "repeat", 

	          	"when" => "trigger",
	          	"on" => "trigger",
	          	"tr" => "trigger",
	          	"trig" => "trigger",

	          	"inst" => "instrument",
	          	"ins" => "instrument",
	          	"i" => "instrument",
	          	"n" => "instrument",

	          	"rot" => "rotate",

	          	"sh" => "shift",

	          	"lp" => "loop",
	          	"scp" => "loop",
	          	"scope" => "loop",

	          	"mu" => "mute",

	          	"fl" => "flip",
	          	"f" => "flip"
	          }
          end

				   def objectify
					     puts "#{name} RIGHT"
					     @@text = "self.class.include DrumTool::Models::Bubbles\ntrack(&#{@@text})"
						 end
					end
				end
		end
end
            
						