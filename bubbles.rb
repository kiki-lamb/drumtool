#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

easy_start(
  Models::Bubbles::Standard::Preprocessors::Preprocessor,
  Models::Bubbles::Standard.track,
  "input/bubbles2.dt2"
)
