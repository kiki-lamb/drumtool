module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          as_trait do |prefix = nil|
            define_method "#{prefix}events" do
              children.select do |ch|
                ch.respond_to? :events
              end.map do |ch|
                ch.events
              end.flatten(1) # .tap { puts "#{self} events at #{time}" }
            end
          end
        end
      end
    end
  end
end
