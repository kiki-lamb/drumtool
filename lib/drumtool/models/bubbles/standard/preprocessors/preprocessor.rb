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
              chain!
              drop
              flip!
              hard_reverse!
              loop
              mute!
              refresh_interval
              reverse!
              rotate
              scale
              shift
              stretch
              take
              trigger
              untrigger
            }

            synonymize \
              bubble: [:pattern, :part, :scope],
              note: :instrument,
              drop: [ :wait, :rest ],
              take: [ :duration, :truncate ],
              chain!: :sequence,
              hard_reverse!: [ :h_reverse!, :hreverse! ],
              stretch: :expand,
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
