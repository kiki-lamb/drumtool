#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

Preprocessors::Preprocessor.log_to "output/preprocessor"
LivePlayback.log_to                "output/livecoder",  $stdout

LivePlayback.start "input/sample.dt" 


