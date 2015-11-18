module DrumTool
  module Models
    class LighterBubbles
      module Preprocessors
        class Preprocessor < DrumTool::Preprocessors::Base    

          # This class reads new style .dt2 files (scopes starte by '>').
          # If DumberRubifyPythonesqueBlocks stage were initialized with require_prefix = nil,
          # it would read old style .dt files (scopes started by 'instrument' calls).
          
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
             Bubbles::Preprocessors::Stages::Objectify.new("LighterBubbles.track")
        end
      end
    end
  end
end
