module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          def events *klasses
            children.select do |ch|
              ch.respond_to? :events
            end.map do |ch|
              ch.events *klasses
            end.flatten(1) # .tap { puts "#{self} events at #{time}" }            
          end
        end
      end
    end
  end
end
