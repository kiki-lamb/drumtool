module DrumTool
	module Models
		module Bubbles
		  class AbsoluteTimeBubble < RelativeTimeBubble
		    counter_bubble_attr :tick, return_value: :events
		    
				def base_time 
				  tick
				end

				def initialize child_klass = RelativeTimeBubble, *a
				  @child_klass = child_klass
					super *a
				end

		    def bubble &b
		      @child_klass.new(self).build(&b)
		    end
		  end
		end
	end
end
