require "./lib/drumtool"
include DrumTool

obj = eval(Models::Bubbles::Standard::Preprocessors::Preprocessor.new(File.open("input/bubbles2.dt2").read).result)
Playback.new(obj).start

