module DrumTool
	module Preprocessors
	  module Stages
		  class Procify < Base
			  def call
			    "Proc.new {\n#{text}\n}"
			  end
			end
		end
	end
end