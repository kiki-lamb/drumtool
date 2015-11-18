module DrumTool
	module Models
		class Bubbles
      module Traits
		  module Events
			  def self.included base
				  base.proximal_bubble_toggle :mute
				end														

		    def events
          if mute?
            []
          else
		        [ *local_events,
		          *children.select do |ch|
						    ch.respond_to? :events
						  end.map do |ch|
		            ch.events
		          end.flatten(1)
		        ].compact
          end
		    end

				private
				def local_events 
				  []
				end
		  end
      end
		end
	end
end
