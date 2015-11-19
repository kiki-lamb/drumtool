#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
puts "BIP: `#{ARGV[0]}'"

easy_start(
  Models::Bubbles::Standard::Preprocessors::Preprocessor,
  Models::Bubbles::Standard.track,
  ARGV[0] || "input/bsample.dt"
)
