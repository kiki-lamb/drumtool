require "./drum"

puts Drum::LiveCoder.preprocess(File.open("input.dt").read)
lc = Drum::LiveCoder.new("input.dt").run

