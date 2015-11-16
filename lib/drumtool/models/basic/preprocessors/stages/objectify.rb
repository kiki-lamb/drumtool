module DrumTool
  module Models
	  module Basic
		  module Preprocessors
			  module Stages
	  		  class Objectify < DrumTool::Preprocessors::Stages::Base
		  	    def call
			       "Models::Basic.build(&#{text})"
			      end
					end
				end
			end
		end
	end
end