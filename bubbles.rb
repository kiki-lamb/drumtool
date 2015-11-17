#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

easy_start Models::Bubbles::Preprocessors::Preprocessor, Models::Bubbles.track, "input/bubbles.dt2"
