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
              sequence!
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

              filter
               min?
               max?
               range?
               in_scale?

              xform
               name
               octave
               remap
               semitones
               to_scale
            }

            synonymize \
              bubble: [:pattern, :part, :scope],
              note: :instrument,
              semitones: [ :transpose, :semis ],
              drop: [ :wait, :rest ],
              take: [ :duration, :truncate ],
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
              StripBlankLinesAndTrailingWhitespaceAndComments,
              Objectify.new("Bubbles::Standard.track")
          end
        end
      end
    end
  end
end
