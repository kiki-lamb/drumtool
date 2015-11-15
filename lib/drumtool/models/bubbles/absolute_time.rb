module DrumTool
	module Models
		module Bubbles
		  class AbsoluteTime < RelativeTime
		    counter_bubble_attr :tick, return_value: :events
		    
				def base_time 
				  tick
				end

				def initialize child_klass = RelativeTime, *a
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
