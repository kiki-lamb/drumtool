require_relative "./drum/engine"
require_relative "./drum/live_coder"

class Drum
  class << self
    def build &b
      Engine.new.build &b
    end
  end
end
