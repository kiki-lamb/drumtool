#!/usr/bin/env ruby
require_relative "./lib/drumtool"

LiveCoder.play \
  "input/sample.dt", 
  refresh_interval: 1, 
	rescue_eval: false, 
	logger: $stdout, 
	pp_logger: File.open("output/preprocessor", "w")
