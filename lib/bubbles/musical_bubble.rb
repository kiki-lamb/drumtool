class Bubbles
  class MusicalBubble < Bubble
    bubble_attr :loop, default: nil

    proximal_bubble_toggle :mute
    
    bubble_attr :rotate
    bubble_attr :shift
    bubble_attr :scale

    def time  
      base = (parent ? parent.time : tick) 
      e_time = (base * (2**(-scale))).to_f
      e_time -= rotate
      e_time %= loop if loop
      e_time -= shift
      e_time # .tap { |x| puts "#{tick} #{self} OUT: #{base} -> #{x}" }
    end

    def active? 
      # puts "#{" "*depth}(MB) #{self}.active? #{time}"
      ! mute?
    end

    def events force: false
      # puts "#{" "*depth}(MB) #{self}.events #{time}, #{force ? "true" : "false"}"

      (
        self.children.map do |ch|
          ch.events
        end.flatten(1) if (force || active?)
      ) || []
    end
  end
end
