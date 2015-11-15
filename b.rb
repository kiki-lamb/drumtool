#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models::Bubbles

Preprocessors::BubblePreprocessor.log_to "output/bubble_preprocessor"
LivePlayback.log_to                      "output/bubble_livecoder",  $stdout

LivePlayback.start "input/sample.dt", preprocessor: Preprocessors::BubblePreprocessor # , init: track


