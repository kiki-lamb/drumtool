
module DrumTool
  class Note
    attr_accessor :number, :name, :channel, :velocity
    def short_name
      name[0..1].ljust 2, " "
    end
    
    def merge! other
      self.number   ||= other.number
      self.channel  ||= other.channel
      self.velocity ||= other.velocity
      self
    end
    
    def initialize name: nil, number: nil, velocity: 100, channel: nil
      self.name     = name
      self.number   = number
      self.channel  = channel
      self.velocity = velocity
    end
  end
end
		  
		
