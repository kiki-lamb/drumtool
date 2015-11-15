module DrumTool
	module Models
		module Bubbles
		  module Events
			  def self.included base
				  base.proximal_bubble_toggle :mute
				end														

		    def events
		      [ local_events,
		        *self.children.select do |ch|
						  ch.respond_to? :events
						end.map do |ch|
		          ch.events
		        end
		      ].flatten(1).compact unless mute?
		    end

				private
				def local_events 
				  []
				end
		  end
		end
	end
end
