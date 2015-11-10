require "./lib/drum"

file = "input.dt"

puts Drum::LiveCoder::Preprocessor.call File.open(file).read, logger: $stdout

Drum::LiveCoder.play file