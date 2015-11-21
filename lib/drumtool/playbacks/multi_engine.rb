module DrumTool
  module Playbacks
    class MultiEngine
      include EngineInterface
      # These are all of the methods called on the engine by any of the Playback classes.

      def initialize *engines
        raise "Incompatible engine" unless engines.all? do |e|
          EngineInterface === e
        end
        
        (@engines = engines) # .tap { |x| puts "ENGINES: #{x.inspect}" }
      end
      
      def displayed_notes
        @engines.map(&:displayed_notes).flatten(1) # .tap { |x| puts "displayed_notes: #{x.inspect}" }
      end

      def events
        @engines.map(&:events).flatten(1) # .tap { |x| puts "events: #{x.inspect}" }
      end
      
      def bpm
        @engines.first.bpm # .tap { |x| puts "bpm: #{x.inspect}" }
      end
      
      def tick!
        @engines.each(&:tick!) # .tap { |x| puts "tick!: #{x.inspect}" }
      end

      def time
        @engines.first.time # .tap { |x| puts "time: #{x.inspect}" }
      end
      
      def time= v
        @engines.each do |e|
          e.time = v
        end
      end
      
      def loop
        @engines.map(&:loop).compact.max # .tap { |x| puts "loop: #{x.inspect}" }
      end
      
      def state
        @engines.first.state # .tap { |x| puts "state: #{x.inspect}" }
      end
      
      def state= h
        @engines.each do |e|
          e.state = h
        end         
      end
    end
  end
end

