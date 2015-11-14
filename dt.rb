#!/usr/bin/env ruby
require_relative "./lib/models/drum"

file = "input/sample.dt"

LiveCoder.play file, refresh_interval: 1, rescue_eval: false, logger: $stdout, pp_logger: File.open("output/preprocessor", "w")