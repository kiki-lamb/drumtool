module DrumTool
	module Models
		module Basic
		  class << self
		    def build &b
		      Engine.new.build &b
		    end
		  end
		end
	end
end