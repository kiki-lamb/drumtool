module DrumTool
  module Preprocessors
    module Stages
      class Splitify < Base
        def call         
          splitter.source
        end

        def splitter
          @splitter ||= Splitter.new text
        end

        def ruby
          splitter.ruby
        end
      end
    end
  end
end
