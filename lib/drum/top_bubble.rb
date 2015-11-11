require_relative "./musical_bubble"
require_relative "./child_bubble"

require "unimidi"

class Drum
  class TopBubble < MusicalBubble
	 	attr_reader :output
	 
    local_bubble_attr :tick, default: 0
	  local_bubble_attr :refresh, default: 16
		local_bubble_attr :bpm, default: 112 do
		  @tick_length = nil
		end

	 	def tick_length
	 	  @tick_length ||= 60.0/bpm/4
	 	end

   	def initialize *a, output: UniMIDI::Output[0], &b
		  @output = output
	 	  super *a, &b
 	 	end

		def child &b
		  ChildBubble.new(self).build(&b)
		end
  end
end
