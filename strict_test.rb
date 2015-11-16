#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models

Bubbles::StrictPreprocessor.log_to "output/preprocessor", $stdout

filename = ARGV[0] || "input/sample3.dt"
$stdout << "Preprocessing " << filename << "\n"

Bubbles::StrictPreprocessor.new(File.open(filename)).result



