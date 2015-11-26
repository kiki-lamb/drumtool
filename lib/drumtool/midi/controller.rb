module DrumTool
  module MIDI
    class Controller
      attr_accessor :name, :channel, :cc, :value

      def short_name
        name[0..1].ljust 2, " "
      end
        
      def initialize name: nil, cc: 0, value: 0,  channel: 1
        self.cc = cc
        self.value = value
        self.name = name
        self.channel = channel
      end
    end
  end
end
      
    
