module DrumTool
  module Models
		class Bubbles
      module Standard
        module Preprocessors
          class Preprocessor < DrumTool::Preprocessors::Base    
            include Stages
            
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
              extend
            }

            synonymize \
              bubble: [:pattern, :part, :scope],
              note: :instrument,
              extend: :stretch,
              trigger: [ :when, :on ],
              untrigger: [ :off, :except, :exclude, :unless ]

            stages \
              Splitify,
              Untabify,
              NormalizeFullLineComments,
              StripBlankLinesAndTrailingWhitespaceAndComments.new(exclude: /\s*>/),
              RubifyArgumentsAndExpandAbbreviations,
              DumberRubifyPythonesqueBlocks.new(require_prefix: true, enable_block_comments: true),
              Objectify.new("Bubbles::Standard.track")
          end
        end
      end
    end
  end
end
