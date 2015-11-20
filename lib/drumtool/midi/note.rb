module DrumTool
  module MIDI
    class Note
      attr_accessor :number, :name, :channel, :velocity, :action
      def short_name
        name[0..1].ljust 2, " "
      end
      
      def merge! other
        return unless other
        
        self.name     ||= other.name
        self.number   ||= other.number
        self.channel  ||= other.channel
        self.velocity ||= other.velocity
        self.action  ||= other.action
        self
      end

      def process!
        self.action.(self) if self.action
      end
      
      def initialize name: nil, number: nil, velocity: 100, channel: 1, &b
        self.name     = name
        self.number   = number
        self.channel  = channel
        self.velocity = velocity
        self.action   = b
      end
    end
  end
end
		  
		
