require "./lib/drum"
require "./lib/drum/live_coder/improved_preprocessor"

file = "input.dt"

puts Drum::LiveCoder::ImprovedPreprocessor.call File.open(file).read

#Drum::LiveCoder.play file, preprocessor: Drum::LiveCoder::ImprovedPreprocessor

