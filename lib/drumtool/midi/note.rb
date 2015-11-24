module DrumTool
  module MIDI
    class Note
      attr_accessor :name, :channel, :velocity
      attr_writer :number

      def note= x
        self.number = x.to_i
        self.number %= 128
      end

      def note
        self.number
      end
      
      def short_name
        name[0..1].ljust 2, " "
      end

      def number
        (@number ||= nil).to_i if @number
      end
      
      def merge! other
        return unless other
        
        self.name     ||= other.name
        self.number   ||= other.number
        self.channel  ||= other.channel
        self.velocity ||= other.velocity
        self
      end
        
      def initialize name: nil, number: nil, velocity: 100, channel: 1
        self.name     = name
        self.number   = number
        self.channel  = channel
        self.velocity = velocity
      end
    end
  end
end
      
    
