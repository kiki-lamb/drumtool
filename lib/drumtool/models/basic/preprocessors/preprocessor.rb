module DrumTool
  module Models
    module Basic
      module Preprocessors
        class Preprocessor < DrumTool::Preprocessors::Base
          include Stages

          # This class will read old style .dt files (scopes started by 'instrument' calls).
          # Making it read .dt2 files (scopes started by '>') would be a bit of a pain in the ass,
          # so I may not bother. -KL          

          abbreviate %i{
            flip
            instrument
            loop
            mute
            refresh_interval
            rotate
            scale
            shift
            trigger
            untrigger
          }

          synonymize \
            loop: [ :pattern, :part, :scope, :bubble ],
            trigger: [ :when, :on ],
            untrigger: [ :not, :except, :exclude ],
            instrument: :note

          stages \
             Splitify,
             Untabify,
             NormalizeFullLineComments,
             StripBlankLinesAndTrailingWhitespaceAndComments,
             RubifyArgumentsAndExpandAbbreviations,
             RubifyPythonesqueBlocks,
             Procify,
             Objectify
        end
      end
    end
  end
end
