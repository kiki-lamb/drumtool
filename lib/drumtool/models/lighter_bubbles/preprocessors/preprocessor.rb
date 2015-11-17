module DrumTool
  module Models
    class LighterBubbles
      module Preprocessors
        class Preprocessor < DrumTool::Preprocessors::Base    
          include Stages

          abbreviate %i{
            bubble
            flip
            instrument
            loop
            mute!
            note
            refresh_interval
            rotate
            scale
            shift
            trigger
            untrigger
          }

          synonymize \
            bubble: [:pattern, :part, :scope],
            trigger: [ :when, :on ],
            untrigger: [ :not, :except, :exclude ]

          stages \
             Splitify,
             Untabify,
             NormalizeFullLineComments,
             StripBlankLinesAndTrailingWhitespaceAndComments,
             RubifyArgumentsAndExpandAbbreviations,
             DumberRubifyPythonesqueBlocks,
             StripBlankLinesAndTrailingWhitespace,
             Objectify
        end
      end
    end
  end
end
