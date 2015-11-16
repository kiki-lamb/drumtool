#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models
include DrumTool::Preprocessors

BubblePreprocessor.log_to "output/preprocessor"
LivePlayback.log_to       "output/livecoder",  $stdout

LivePlayback.start "input/sample.dt", preprocessor: BubblePreprocessor, init: Bubbles.track


