#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

Preprocessors::Preprocessor.log_to "output/preprocessor"
Live.log_to                        "output/livecoder",  $stdout

Live.start "input/sample.dt" #, clock: UniMIDI::Input[1]


