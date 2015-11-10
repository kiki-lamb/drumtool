require "./lib/drum"
require "./lib/drum/live_coder/improved_preprocessor"

file = "input.dt"

Drum::LiveCoder.play file# ,  preprocessor: Drum::LiveCoder::ImprovedPreprocessor #, logger: $stdout