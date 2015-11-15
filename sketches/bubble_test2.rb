#!/usr/bin/env ruby
require "topaz"
require_relative "../lib/drumtool"

include DrumTool::Models::Bubbles

tb = 	track do
	loop(0x40)
	bpm(96)
	refresh_interval(0x08)

	instrument(:bd, 36) do 
	 trigger((Proc.new { |t| t%0x4 }))
	end
end

DrumTool::Playback.log_to $stdout

DrumTool::Playback.start tb



