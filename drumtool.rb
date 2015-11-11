require "./lib/drum"

file = "input.dt"

#Drum::LiveCoder::Preprocessor.call File.open(file).read

Drum::LiveCoder.play file, refresh_interval: 1, rescue_eval: true, logger: $stdout