#!/usr/bin/env ruby
require_relative "./lib/drumtool"

include DrumTool

easy_start Models::LighterBubbles::Preprocessors::Preprocessor, Models::LighterBubbles.track, "input/bubbles.dt2"
