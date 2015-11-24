module DrumTool
  module Models
    class Bubbles
      module Standard
        class Pattern < Track
          include Traits

          prepend Time::Relative::EnhancedLooping

          prepend Events::MIDINotes

          prepend Events::MIDINotes::Transform
          include Events::MIDINotes::Transform::Remap
          include Events::MIDINotes::Transform::Rename
          include Events::MIDINotes::Transform::Transpose

          prepend Events::MIDINotes::Filters::Scale
          prepend Events::MIDINotes::Filters::MinMax

          prepend Events::Triggered
          prepend Events::Muteable
        end
      end
    end
  end
end
