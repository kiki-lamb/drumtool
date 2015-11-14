module DrumTool
	module Models
		module Basic
		  class Engine
		    include TimingScope

		    dsl_attr :refresh_interval, scopable: false
		    dsl_attr :bpm, scopable: false

		    def initialize bpm: 128, &b
		      @bpm = bpm
		      super nil, &b
		    end
		  end
		end
	end
end