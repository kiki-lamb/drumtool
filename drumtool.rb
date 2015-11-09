require "./lib/drum"

puts Drum::LiveCoder::Preprocessor.call(File.open("input.dt").read)
lc = Drum::LiveCoder.new("input.dt").run

