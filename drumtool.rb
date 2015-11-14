require "./lib/models/drum"

file = "input/sample.dt"

Drum::LiveCoder.play file, refresh_interval: 1, rescue_eval: false, logger: $stdout, pp_logger: File.open("pp_out", "w")