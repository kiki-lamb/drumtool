#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models::Bubbles::Standard

easy_start(
  Preprocessors::Preprocessor,
  track,
  ARGV[0] || "input/new.dt2",
  UniMIDI::Input[1],
  rescue_exceptions: false,
  output: UniMIDI::Output[0],
  # logs: [],
  preprocessor_logs: [],
  loader: MultiLoader.new(
    Preprocessors::Preprocessor,
    "input/new.dt2",
    "input/bubbles2.dt2",
    init: track,
    rescue_exceptions: false
    )
)
