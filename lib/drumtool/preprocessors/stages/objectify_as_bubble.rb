module DrumTool
	module Preprocessors
	  module Stages
		  class ObjectifyAsBubble < Base
			  def call
			    "self.class.include DrumTool::Models\nBubbles.track do \n#{text}end"
			  end
			end
		end
	end
end