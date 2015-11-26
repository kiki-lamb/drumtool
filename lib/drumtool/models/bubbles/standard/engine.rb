module DrumTool
  module Models
    class Bubbles
      module Standard
        class Engine
          include Traits          
          include BubbleAttrs
          
          include TreeOf[ Track ]

          prepend EngineInterface
          prepend Time::Absolute[ 6 ]

          include Events
          prepend Events::MIDI::Notes::Table


        end
      end
    end
  end
end
