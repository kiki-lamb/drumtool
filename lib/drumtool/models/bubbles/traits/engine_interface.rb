module DrumTool
	module Models
		class Bubbles
      module Traits
		    module EngineInterface
          # These are all of the methods called on the engine by any of the Playback classes.
          
          def self.prepended base
            base.include Playbacks::EngineInterface
		        base.bubble_attr :refresh_interval, default: nil
		        base.bubble_attr :bpm, default: nil
            base.class_eval do
              include Events         
              prepend Events::MIDINotes::Table
            end
          end
          
          def tick!
            time!
          end

          def time= v
            @time = v
          end
                    
          def loop
            if children.first
              children.map(&:loop).compact.max
            else
              nil
            end
          end
          
          def state
            { bpm: bpm, refresh_inteval: refresh_interval, time: time }
          end

          def state= h
            @bpm ||= h[:bpm]
            @refresh_interval ||= h[:refresh_interval]
            time h[:time]
          end
        end
      end
		end
	end
end
