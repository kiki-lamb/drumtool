module DrumTool
	module Models
		class Bubbles
      module Traits
		    module Engine
				  def self.included base
		        base.bubble_attr :refresh_interval, default: nil
		        base.bubble_attr :bpm, default: nil
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
          
				  def events_at t
				    time t
					  events
				  end				
		    end
      end
		end
	end
end
