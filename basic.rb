#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

easy_start Models::Basic::Preprocessors::Preprocessor, Models::Basic::TimingScope.new, "input/basic.dt"
