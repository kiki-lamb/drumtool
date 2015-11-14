module DrumTool
	module Models
		module Basic
		  class << self
		    def build &b
		      Engine.new &b
		    end
		  end
		end
	end
end