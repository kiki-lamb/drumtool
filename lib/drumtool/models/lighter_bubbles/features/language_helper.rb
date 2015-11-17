module DrumTool
  module Models
		class LighterBubbles
		  module LanguageHelper
			  def instrument name, note, &b
				  bubble.build do
					  note name, note
					end.build &b
				end
			end
		end
	end
end
