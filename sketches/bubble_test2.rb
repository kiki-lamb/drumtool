#!/usr/bin/env ruby
require "topaz"
require_relative "../lib/drumtool"

include DrumTool::Models::Bubbles

tb = 	track do
	loop(0x40)
	bpm(96)
	refresh_interval(0x08)
	scale(1) do 
	  instrument(:rs, 38) do 
	   trigger(0, 1, 3, 6, 11, 16, 22, 29, 37, 45, 55, 66)
	   loop(0x20)
	  end
	end
	scale(1) do 
	 instrument(:bd, 36) do 
	  trigger((Proc.new { |t| t%0x5 }))
	  loop(0x08)
	 end
	 instrument(:ch, 41) do 
	  trigger((Proc.new { |t| t%1 }))
	  untrigger(2)
	  loop(0x4)
	  mute
	 end
	 instrument(:oh, 39) do 
	  shift(2)
	  trigger((Proc.new { |t| t%4 }))
	 end
	 instrument(:sd, 37) do 
	  rotate(4)
	  scale -1
	  trigger((Proc.new { |t| t%8 }))
	 end
	end
	scale(3) do 
	 instrument(:bs, 40) do 
	  loop(0x10)
	  shift(2)
	  trigger((Proc.new { |t| t%5 }))
	 end
	end
	loop(0x20) do 
	  scale(1)
	  instrument(:sy, 49) do 
	   shift(2)
	   trigger((Proc.new { |t| t%5 }))
	   loop(8)
	  end
	end
	instrument(:s2, 47) do 
	 loop(0x20)
	 trigger((Proc.new { |t| t%9 }))
	end
	instrument(:t2, 46) do 
	 scale(0)
	 trigger((Proc.new { |t| t%6 }))
	 loop(0x10)
	 shift(2)
	end
end

DrumTool::Playback.start tb



