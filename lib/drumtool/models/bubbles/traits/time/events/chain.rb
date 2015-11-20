module DrumTool
  module Models
    class Bubbles
      module Traits
        module Time
        module Events
        module Chain
					def self.included base
				    base.bubble_toggle :chain
            base.instance_eval do
              attr_accessor :disabled_children
              attr_accessor :times_seen
            end
				  end														

          private
          def local_events
            if chain?
              raise ArgumentError, "Children must be looped." unless children.all? { |c| c.loop && c.loop != 0 }
              
              if self.disabled_children && children.any? && times_seen.include?(children.first.time)
                children.unshift *self.disabled_children
                self.disabled_children = nil
              end

              self.disabled_children ||= begin
                                           self.times_seen = []
                                           tmp = children[1..-1]
                                           children_array [children[0]]
                                           tmp
                                         end
              
              self.times_seen << children.first.time if children.first
            end

            super
          end
        end
      end
    end
  end
end
end
end
