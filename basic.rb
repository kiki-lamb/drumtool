#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool
include DrumTool::Models

Basic::Preprocessor.log_to "output/preprocessor"
LivePlayback.log_to                "output/livecoder",  $stdout

LivePlayback.start "input/sample3.dt", preprocessor: Basic::Preprocessor, init: Models::Basic::TimingScope.new


