require "./lib/drum"
require "./lib/drum/live_coder/improved_preprocessor"

file = "input.dt"

Drum::LiveCoder::ImprovedPreprocessor.call File.open(file).read, logger: $stdout

# Drum::LiveCoder.play file, preprocessor: Drum::LiveCoder::ImprovedPreprocessor

