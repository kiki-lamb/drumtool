module DrumTool
  module Playbacks
    module Engine
      module Interface
        # These are all of the methods called on the engine by any of the Playback classes.
        
        def displayed_notes
          raise NotImplementedError
        end
        
        def events
          raise NotImplementedError
        end
        
        def bpm
          raise NotImplementedError
        end
        
        def tick!
          raise NotImplementedError
        end
        
        def time
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
end
