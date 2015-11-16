#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

Preprocessors::BasicPreprocessor.log_to "output/preprocessor"
LivePlayback.log_to                "output/livecoder",  $stdout

LivePlayback.start "input/sample3.dt" 


