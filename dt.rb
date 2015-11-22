#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models::Bubbles::Standard

Preprocessors::Preprocessor.log_to  "output/preprocessor"

easy_start(
  nil, #Preprocessors::Preprocessor,
  track,
  ARGV[0] || "input/new.dt2",
  #UniMIDI::Input[1],
  rescue_exceptions: false,
  output: UniMIDI::Output[0],
  # logs: [],
  preprocessor_logs: ["output/preprocessor", $stdout],
  loader: MultiLoader.new(
    Preprocessors::Preprocessor,
    "input/new2.dt2",
#    "input/bubbles2.dt2",
    init: track,
    rescue_exceptions: false
    )
)
