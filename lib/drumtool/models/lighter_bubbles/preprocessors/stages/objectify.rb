module DrumTool
  module Models
	  class LighterBubbles
		  module Preprocessors
			  module Stages
	  		  class Objectify < DrumTool::Preprocessors::Stages::Base
		  	    def call
			       "self.class.include DrumTool::Models\nLighterBubbles.track do \n#{text}end"
			      end
					end
				end
			end
		end
	end
end
