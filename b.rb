#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models::Bubbles

Preprocessors::BubblePreprocessor.log_to "output/bubble_preprocessor", $stdout
LivePlayback.log_to                      "output/livecoder",  $stdout

LivePlayback.start "input/bsample.dt", preprocessor: Preprocessors::BubblePreprocessor, init: track


