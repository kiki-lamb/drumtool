require_relative "./musical_bubble"

class Drum
  class ChildBubble < MusicalBubble
	  local_hash_bubble_attr :notes, flip: true, permissive: true

		def clear_cache
		  cache_hash {}
		end

		local_array_bubble_attr :triggers, singular: :add_trigger, &:clear_cache
		local_array_bubble_attr :untriggers, singular: :add_untrigger, &:clear_cache
		local_hash_bubble_attr :cache, singular: :add_cache

		proximal_bubble_toggle :flip

		def tick
		  top.tick
		end

		%i{ trigger untrigger }.each do |method_name|
    	define_method method_name do |*args, &condition|
    	 if args.any?
    	   ranges, args = args.partition do |arg|
    	     Range === arg
    	   end

    	   fixnums, args = args.partition do |arg|
    	     Fixnum === arg
    	   end
    	 
    	   procs, others = args.partition do |arg|
    	     Proc === arg
    	   end

    	   raise ArgumentError, "Invalid argument: #{others.first.class.name} `#{others.first.inspect}'." if others.any?

    	   if fixnums.count == 1
    	     send method_name  do |t|
    	       fixnums.first == t
    	     end
    	   elsif fixnums.count > 1
    	     send method_name do |t|
    	       fixnums.include? t
    	     end
    	   end

    	   ranges.each do |range|
    	     send method_name do |t|
    	       range.include? t
    	     end
    	   end

    	   procs.each do |proc|
    	     send method_name, &proc
    	   end
    	 end

			 send("add_#{method_name}", condition) if condition
    	end
    end

 	  def trigger_fires? trigger, time
     	tmp = instance_exec(time, &trigger)

     	if Fixnum === tmp || Float === tmp
     	  0 == tmp
     	else
     	  tmp
     	end
    end

		def to_s
		  "#{super}(#{notes.values.join ", "})"
		end

		def events force: false
		  # puts "#{" "*depth}(CB) #{self}.events #{time}, #{force ? "true" : "false"}"
		  (force || fires?) ? (notes.to_a.map(&:reverse!) + super(force: true)) : []
		end
		
    def fires? 
		  # puts "#{" "*depth}(CB) #{self}.fires? #{time}"

		  return false unless super

      e_time   =  time
	    e_time   =  (e_time * (2**(-scale))).to_f
      e_rotate =  rotate || 0
      e_shift  =  shift || 0
      e_time   -= e_rotate
#      e_time   %= loop if loop
      e_time   -= e_shift

      fires_now = cache[e_time] ||= begin
				if triggers.any? do |t|
          trigger_fires? t, e_time
        end
				  ! untriggers.any? do |t|
            trigger_fires? t, e_time
          end
			  end
			end
    end
  end
end