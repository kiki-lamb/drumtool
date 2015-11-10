require "./lib/drum"

file = "input.dt"

# puts Drum::LiveCoder::Preprocessor.call File.open(file).read, logger: $stdout

Drum::LiveCoder.play file, refresh_interval: 1, rescue_eval: true