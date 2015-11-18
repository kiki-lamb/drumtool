module DrumTool
  module Models
    class Bubbles
      module Traits
        module Chain
					def self.included base
				    base.bubble_toggle :chain
            base.instance_eval do
              attr_accessor :top_child
              attr_accessor :times_seen
            end
				  end														

          private
          def local_events
            if chain?
              raise ArgumentError, "Children must be looped." unless children.all? { |c| c.respond_to? :loop }
              
              if top_child && times_seen.include?(top_child.time)
                children.push top_child
                self.top_child = nil
              end
                 
              self.top_child ||= begin
                                   self.times_seen = []
                                   children.shift
                                 end
#              puts "#{self}: #{top_child} sees #{top_child.time} at #{time}"
              
              if top_child
                self.times_seen << top_child.time
                top_child.events#.tap { |y| puts "Y = #{y.inspect}" }
              end || []
            else
              super
            end
          end
        end
      end
    end
  end
end
