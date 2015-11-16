#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

Preprocessors::StricterBubblePreprocessor.log_to "output/preprocessor", $stdout

filename = ARGV[0] || "input/sample3.dt"
$stdout << "Preprocessing " << filename << "\n"

Preprocessors::StricterBubblePreprocessor.new(File.open(filename)).result



