#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Preprocessors

Preprocessor.log_to "output/preprocessor"
Playback.log_to $stdout, "output/livecoder"

Playback.start \
  "input/sample.dt"
 #,
#	clock: UniMIDI::Input[1]


