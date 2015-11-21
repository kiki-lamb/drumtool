module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          def self.included base
            base.instance_eval do
              attr_accessor :event_cache
            end
          end
          
          def events
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
