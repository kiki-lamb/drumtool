module DrumTool
  module Preprocessors
    module Stages
      class Untabify < Base
        def call
          text.gsub /\t/m, '  '       
        end
      end
    end
  end
end
