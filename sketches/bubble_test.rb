#!/usr/bin/env ruby

require_relative "../lib/drumtool"
include DrumTool::Models::Bubbles

tb = bubble do
  bubble do
	  trigger { |t| 0 == t % 4 }
	  note :bd, 36     
  end

	rotate 1 do
		bubble do
		  note :sd, 37
		  trigger { |t| 0 == (t+4) % 8 }
		end
  end
end

16.times do
		puts "#{tb.tick} #{tb.tick!}"
end


