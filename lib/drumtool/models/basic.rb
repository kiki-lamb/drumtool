module DrumTool
  module Models
    module Basic
      class << self
        def build &b
          TimingScope.new &b
        end
      end
    end
  end
end
