#!/usr/bin/env ruby
require "topaz"
require_relative "../lib/drumtool"

include DrumTool::Models::Bubbles

tb = track do
  bubble do
	  trigger { |t| 0 == t % 4 }
	  note :bd, 36     
  end

  bubble do
		note :sd, 37
		trigger { |t| 0 == (t+4) % 8 }
  end
end

DrumTool::Playback.start tb



