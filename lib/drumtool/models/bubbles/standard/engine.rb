module DrumTool
  module Models
    class Bubbles
      module Standard
        class Engine
          include Traits          
          include BubbleAttrs
          include TreeOf[ Track ]
          include Time::Absolute[ 6 ]
          prepend EngineInterface
          include Events
          prepend Events::MIDI::Notes::Table
        end
      end
    end
  end
end
