module DrumTool
  class Note
    attr_writer    :open
    attr_accessor :number, :name, :channel, :velocity
    
		def open?
      !! @open
    end
    
    def short_name
      name[0..1].upcase.ljust 2, " "
    end
    
    def initialize name: nil, number: nil, channel: nil, velocity: 100, open: false
      self.name     = name
      self.number   = number
      self.channel  = channel
      self.velocity = velocity
      self.open     = open

      raise ArgumentError, "You must specify a name for this note" unless self.name
    end
  end
end
		  
		
