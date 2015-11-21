#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models::Bubbles::Standard

easy_start(
  Preprocessors::Preprocessor,
  track,
  ARGV[0] || "input/new.dt2",
  false,
  rescue_exceptions: false
)
