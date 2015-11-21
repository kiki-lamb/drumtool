module DrumTool
    module Playbacks
      module EngineInterface
        # These are all of the methods called on the engine by any of the Playback classes.

        def bpm
          raise NotImplementedError
        end
        
        def tick!
          raise NotImplementedError
        end
        
        def time= v
          raise NotImplementedError
        end
        
        def loop
          raise NotImplementedError
        end
        
        def state
          raise NotImplementedError
        end
        
        def state= h
          raise NotImplementedError
        end
      end
    end
  end

