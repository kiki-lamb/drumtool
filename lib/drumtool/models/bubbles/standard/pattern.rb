module DrumTool
  module Models
    class Bubbles
      module Standard
        class Pattern < Track
          include Traits

          prepend Time::Relative::EnhancedLooping

          prepend Events::MIDI::Notes
            include Events::MIDI::Notes::Helpers::ScaleNotes

          prepend Events::Transform
          prepend Events::Transform::WithContextSetVia[:parent=]
            include Events::MIDI::Notes::Transform::Attributes
            include Events::MIDI::Notes::Transform::Rename
            include Events::MIDI::Notes::Transform::Transpose
            include Events::MIDI::Notes::Transform::Remap
            include Events::MIDI::Notes::Transform::Remap::ToScale

          prepend Events::Filter          
            include Events::MIDI::Notes::Filter::MinMax
            include Events::MIDI::Notes::Filter::InScale
            
          prepend Events::MIDI::Controllers
          prepend Events::MIDI::Controllers::Transform::Attributes

          prepend Events::Triggered
          prepend Events::Muteable
        end
      end
    end
  end
end
