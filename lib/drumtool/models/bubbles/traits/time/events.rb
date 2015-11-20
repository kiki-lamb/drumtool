module DrumTool
	module Models
		class Bubbles
      module Traits
        module Time
		  module Events
			  def self.included base
				  base.proximal_bubble_toggle :mute
          base.instance_eval do
            attr_accessor :event_cache
          end
				end														

		    def events
          if mute?
            []
          else
            (self.event_cache ||= {})[time] ||= local_events
          end
		    end

				private
				def local_events 
				  children.select do |ch|
						ch.respond_to? :events
					end.map do |ch|
		        ch.events
		      end.flatten(1).compact
				end
		  end
      end
		end
	end
end
end
