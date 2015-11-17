module DrumTool
  module Models
	  class Bubbles
		  module Preprocessors
			  module Stages
	  		  class Objectify < DrumTool::Preprocessors::Stages::Base
            def initialize method_name = "Bubbles.track"
              @method_name = method_name
              super
            end

            def call
			       "self.class.include DrumTool::Models\n#{@method_name} do \n#{text}end"
			      end
					end
				end
			end
		end
	end
end
