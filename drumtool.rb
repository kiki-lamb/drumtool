require "./lib/drum"

file = "input.dt"

puts Drum::LiveCoder::Preprocessor.call File.open(file).read
lc = Drum::LiveCoder.play file

