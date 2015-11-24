module DrumTool
  module Models
    class Bubbles
      module Standard
        class Pattern < Track
          include Traits

          prepend Time::Relative::EnhancedLooping

          prepend Events::MIDINotes
          prepend Events::MIDINotes::Filters::Transpose

          prepend Events::MIDINotes::Filters::Transform
          include Events::MIDINotes::Filters::Transform::Remap
          include Events::MIDINotes::Filters::Transform::Rename

          prepend Events::MIDINotes::Filters::Scale
          prepend Events::MIDINotes::Filters::MinMax

          prepend Events::Triggered
          prepend Events::Muteable
        end
      end
    end
  end
end
