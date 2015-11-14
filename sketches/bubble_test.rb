#!/usr/bin/env ruby
require "topaz"
require_relative "../lib/drumtool"

include DrumTool::Models::Bubbles

tb = bubble do
  rotate -1

  bubble do
	  trigger { |t| 0 == t % 4 }
	  note :bd, 36     
  end

#  bubble do
#	  rotate 1
#		note :sd, 37
#		trigger { |t| 0 == (t+4) % 8 }
#  end
end

################################################################################

input = UniMIDI::Input[1]

clock = Topaz::Clock.new(input, midi_transport: false, interval: 16) do 
		puts "#{Time.now} #{tb.tick} #{tb.tick!}"
end

puts "Waiting for MIDI clock..."
puts "Control-C to exit"
puts

clock.start


