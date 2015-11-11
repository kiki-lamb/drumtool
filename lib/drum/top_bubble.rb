require_relative "./musical_bubble"
require_relative "./child_bubble"

require "unimidi"

class Drum
  class TopBubble < MusicalBubble
	 	attr_reader :output
	 
    local_counter_bubble_attr :tick, return_value: :events, before: :play, after: :rest

	  local_bubble_attr :refresh, default: 16

		local_bubble_attr :bpm, default: 112 do
		  @tick_length = nil
		end

		local_array_bubble_attr :open_notes do |note, is_new|
		  output.puts 0x80, note[1], 100 unless is_new
		  output.puts 0x90, note[1], 100
		end

		def play 
		  events.each do |event|
			  open_note event
			end		
		end
		
		def rest
			sleep tick_length
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