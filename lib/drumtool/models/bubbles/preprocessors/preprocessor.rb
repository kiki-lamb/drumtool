module DrumTool
  module Models
    class Bubbles
      module Preprocessors
        class Preprocessor < DrumTool::Preprocessors::Base    
          include Stages

          abbreviate %i{
            bubble
            flip
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
            note: :instrument,
            trigger: [ :when, :on ],
            untrigger: [ :not, :except, :exclude ]

          stages \
             Splitify,
             Untabify,
             NormalizeFullLineComments,
             StripBlankLinesAndTrailingWhitespaceAndComments,
             RubifyArgumentsAndExpandAbbreviations,
             DumberRubifyPythonesqueBlocks.new(require_prefix: true),
             StripBlankLinesAndTrailingWhitespace,
             Objectify
        end
      end
    end
  end
end
