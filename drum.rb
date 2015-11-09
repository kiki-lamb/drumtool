require "./lib/drum/engine"
require "./lib/drum/live_coder"

class Drum
  class << self
    def build &b
      Engine.new.build &b
    end
  end
end
