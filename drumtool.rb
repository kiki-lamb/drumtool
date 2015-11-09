require "./lib/drum"

file = "input.dt"

puts Drum::LiveCoder::Preprocessor.call File.open(file).read

Drum::LiveCoder.play file

