module DrumTool
  module Models
    class Bubbles
      module Traits
        module PlaybackInterface
          def self.included base
            base.bubble_attr :refresh_interval, default: nil
            base.bubble_attr :bpm, default: nil
            base.class_eval do
              include Events         
              include Events::NotesDisplay              
            end
          end
          
          def tick
            time
          end

          def tick!
            time!
          end

          def loop
            if children.first
              children.first.loop
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
