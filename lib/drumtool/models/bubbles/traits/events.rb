module DrumTool
	module Models
		class Bubbles
      module Traits
		  module Events
        def self.included base
				  base.bubble_toggle :mute
          base.instance_eval do
            attr_accessor :event_cache
          end
        end

		    def events
 #         puts "#{self} CALL Events#events"
          if mute?
            []
          else
#            (self.event_cache ||= {})[time] ||=
              local_events
          end#.tap { |x| puts "#{self} CALL Events#events OUT: #{x.inspect}" }
		    end

				private
				def local_events
#          puts "#{self} CALL Events#local_events IN #{time}"
				  children.select do |ch|
						ch.respond_to? :events
					end.map do |ch|
#            puts "#{self} THIS CHILD: #{ch}"
		        ch.events
		      end.flatten(1).compact #.tap { |x| puts "#{self} CALL Events#local_events OUT: #{x.inspect}" }
				end
		  end
      end
		end
	end
end


