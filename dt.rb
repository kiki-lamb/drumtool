#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Preprocessors

Preprocessor.log_to "output/preprocessor"
LiveCoder.log_to $stdout, "output/livecoder"

LiveCoder.play \
  "input/sample.dt", 
	rescue_exceptions: false

#	clock: UniMIDI::Input[1]
