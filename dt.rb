#!/usr/bin/env ruby
require_relative "./lib/drumtool"

DrumTool::Preprocessors::Preprocessor.log_to File.open("output/preprocessor", "w")

DrumTool::LiveCoder.play \
  "input/sample.dt", 
  refresh_interval: 1, 
	rescue_exceptions: false, 
	log: $stdout #, 
#	preprocessor_log:  #,
#	clock: UniMIDI::Input[1]
