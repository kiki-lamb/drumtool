module DrumTool
	module Models
		module Basic
		  class << self
		    def build output = UniMIDI::Output[0], &b
		      Engine.new(output).build &b
		    end
		  end
		end
	end
end