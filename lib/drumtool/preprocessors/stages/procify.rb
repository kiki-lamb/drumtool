module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
			  def procify text
			    "Proc.new {\n#{text}\n}"
			  end
			end
		end
	end
end