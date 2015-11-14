module DrumTool
	module Models
		module Basic
		  class << self
		    def build output, &b
		      Engine.new(output).tap do |e|
					  e.build &b if b
					end
		    end
		  end
		end
	end
end