module DrumTool
  module Models
    module Basic
      # The classes in this module are pretty obsolete by this point.
      # This module will probably be removed soon.

      class << self
        def build &b
          TimingScope.new &b
        end
      end
    end
  end
end
