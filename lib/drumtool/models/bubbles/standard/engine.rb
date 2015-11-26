module DrumTool
  module Models
    class Bubbles
      module Standard
        class Engine
          include Traits          
          include BubbleAttrs
          
          include TreeOf[ Track ]


          prepend Events
          prepend Events::MIDI::Notes::Table

          prepend EngineInterface
          include Time::Absolute

        end
      end
    end
  end
end
