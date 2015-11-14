require_relative "./drum/engine"
require_relative "../live_coder"

class Models
	class Drum
	  class << self
	    def build &b
	      Engine.new.build &b
	    end
	  end
	end
end