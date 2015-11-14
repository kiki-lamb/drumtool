#!/usr/bin/env ruby
require_relative "./lib/drumtool"

DrumTool::LiveCoder.play \
  "input/sample.dt", 
  refresh_interval: 1, 
	rescue_eval: true, 
	logger: $stdout, 
	pp_logger: File.open("output/preprocessor", "w"),
	clock: UniMIDI::Input[1]
