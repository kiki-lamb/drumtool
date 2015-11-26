module DrumTool
  module Models
    class Bubbles
      module Standard
        class Engine
          include Traits          
          include BubbleAttrs
          
          include TreeOf[ Track ]

          include Time::Absolute

          include Events
          prepend Events::MIDI::Notes::Table

          prepend EngineInterface
        end
      end
    end
  end
end
