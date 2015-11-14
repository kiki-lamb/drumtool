#!/usr/bin/env ruby
require_relative "./lib/drumtool"

DrumTool::LiveCoder.play \
  "input/sample.dt", 
  refresh_interval: 1, 
	rescue_eval: false, 
	log: $stdout, 
	preprocessor_log: File.open("output/preprocessor", "w") #,
#	clock: UniMIDI::Input[1]
