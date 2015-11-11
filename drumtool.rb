require "./lib/drum"

file = "input.dt"

Drum::LiveCoder.play file, refresh_interval: 1, rescue_eval: true, logger: $stdout, pp_logger: File.open("pp_out", "w")