module DrumTool
  module Models
    class Bubbles
      module Standard
        class Pattern < Track
          include Traits

          prepend Time::Relative::EnhancedLooping

          prepend Events::MIDINotes
          prepend Events::Triggered
          prepend Events::MIDINotes::Filters::Transpose
          prepend Events::MIDINotes::Filters::Transform
          prepend Events::MIDINotes::Filters::Scale  
          prepend Events::MIDINotes::Filters::MinMax 
        end
      end
    end
  end
end
