module DrumTool
    module Preprocessors
        class BubblePreprocessor < Preprocessor
				  class << self
	        def abbreviations
					  @abbreviations ||= {
	          	"refr" => "refresh_interval",
	          	"ref" => "refresh_interval",

							"bu" => "bubble",
							"bub" => "bubble",
							"pat" => "bubble",
							"p" => "bubble",
							"pattern" => "bubble",
							"pt" => "bubble",
							"patr" => "bubble",
							"part" => "bubble",
							"ptrn" => "bubble",

							"n" => "note",

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

	          	"rot" => "rotate",

	          	"sh" => "shift",

	          	"lp" => "loop",
	          	"scp" => "loop",
	          	"scope" => "loop",

	          	"mu" => "mute!",
	          	"mute" => "mute!",

	          	"fl" => "flip!",
	          	"f" => "flip!"
	          }
          end

					 def procify
					 end

				   def objectify
					     @@text = "self.class.include DrumTool::Models\nBubbles.track do \n#{@@text}\nend"
						 end
					end
				end
		end
end
            
						