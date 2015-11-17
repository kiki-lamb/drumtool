#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models

LighterBubbles::Preprocessors::Preprocessor.log_to "output/preprocessor", $stdout

filename = ARGV[0] || "input/strict.dt"
$stdout << "Preprocessing " << filename << "\n"

LighterBubbles::Preprocessors::Preprocessor.new(File.open(filename)).result



