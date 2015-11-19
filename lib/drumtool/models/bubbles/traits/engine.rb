module DrumTool
	module Models
		class Bubbles
      module Traits
		    module Engine
				  def self.included base
		        base.bubble_attr :refresh_interval, default: 16
		        base.bubble_attr :bpm, default: 112           
          end

          def tick
            time
          end

          def tick!
            time!
          end

          def state
            { bpm: bpm, refresh_inteval: refresh_interval, time: parent.time }
          end

          def state= h
            bpm h[:bpm]
            refresh_interval h[:refresh_interval]
            parent.time h[:time]
          end
          
				  # This is needed to make it a valid engine for Playbacks:
				  def events_at t
				    parent.time t
					  events
				  end				
		    end
      end
		end
	end
end
