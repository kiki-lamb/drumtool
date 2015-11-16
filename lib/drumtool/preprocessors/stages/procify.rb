module DrumTool
	module Preprocessors
	  module Stages
		  module Procify
			  def self.call pp
			    "Proc.new {\n#{pp.text}\n}"
			  end
			end
		end
	end
end