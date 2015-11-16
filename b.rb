#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models::Bubbles

Preprocessors::BubblePreprocessor.log_to "output/preprocessor"
LivePlayback.log_to                      "output/livecoder",  $stdout

LivePlayback.start "input/sample.dt", preprocessor: Preprocessors::BubblePreprocessor # , init: track


