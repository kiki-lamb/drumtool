module DrumTool
  module Models
	  class Bubbles
		  module Preprocessors
			  module Stages
	  		  class ObjectifyAsBubble < DrumTool::Preprocessors::Stages::Base
		  	    def call
			       "self.class.include DrumTool::Models\nBubbles.track do \n#{text}end"
			      end
					end
				end
			end
		end
	end
end