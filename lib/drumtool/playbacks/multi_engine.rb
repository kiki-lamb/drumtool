module DrumTool
  module Playbacks
    class MultiEngine
      include EngineInterface
      # These are all of the methods called on the engine by any of the Playback classes.

      def initialize *engines
        raise "Incompatible engine" unless engines.all? do |e|
          EngineInterface === e
        end
        
        @engines = engines
      end
      
      def displayed_notes
        @engines.map(&:displayed_notes).flatten 1
      end

      def events
        @engines.map(&:events).flatten 1
      end
      
      def bpm
        @engines.first.bpm
      end
      
      def tick!
        @engines.each &:tick!
      end

      def time
        @engines.first.time
      end
      
      def time= v
        @engines.each do |e|
          e.time = v
        end
      end
      
      def loop
        @engines.map(&:loop).compact.min
      end
      
      def state
        @engines.first.state
      end
      
      def state= h
        @engines.each do |e|
          e.state = h
        end         
      end
    end
  end
end

