module DrumTool
  module Models
    class Bubbles
      module Standard
        class Pattern < Track
          include Traits

          prepend Time::Relative::EnhancedLooping

          prepend Events::MIDINotes
          include Events::MIDINotes::Helpers::ScaleNotes

          prepend Events::Transform
          prepend Events::Transform::WithContextSetVia[:parent=]
          include Events::MIDINotes::Transform::Rename
          include Events::MIDINotes::Transform::Remap
          include Events::MIDINotes::Transform::Transpose
          include Events::MIDINotes::Transform::ToScale
          
          prepend Events::Filter          
          include Events::MIDINotes::Filter::MinMax
          include Events::MIDINotes::Filter::InScale

          prepend Events::Triggered
          prepend Events::Muteable
        end
      end
    end
  end
end
