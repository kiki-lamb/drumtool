#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

Preprocessors::StricterBubblePreprocessor.log_to "output/preprocessor", $stdout

Preprocessors::StricterBubblePreprocessor.new(File.open("input/strict.dt")).result



