require_relative "./basic/engine"
require_relative "../live_coder"

class Models
	class Basic
	  class << self
	    def build &b
	      Engine.new.build &b
	    end
	  end
	end
end