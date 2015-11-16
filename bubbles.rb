#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models

Bubbles::Preprocessor.log_to "output/preprocessor"
LivePlayback.log_to       "output/livecoder",  $stdout

filename = ARGV[0] || "input/sample3.dt"
$stdout << "Begin playback of " << filename << "\n"

LivePlayback.start filename, preprocessor: Bubbles::Preprocessor.new, init: Bubbles.track