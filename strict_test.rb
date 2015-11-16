#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models

Bubbles::Preprocessors::StrictPreprocessor.log_to "output/preprocessor", $stdout

filename = ARGV[0] || "input/strict.dt"
$stdout << "Preprocessing " << filename << "\n"

Bubbles::Preprocessors::StrictPreprocessor.new(File.open(filename)).result



