module DrumTool
	module Models
		module Bubbles
		  class TriggeredBubble < EngineBubble
		    hash_bubble_attr :cache, singular: :add_cache
		    proximal_bubble_toggle :flip
		    bubble_toggle :on

		    array_bubble_attr :triggers, singular: :add_trigger do |v|
		      clear_cache
		    end

		    array_bubble_attr :untriggers, singular: :add_untrigger do |v|
		      clear_cache
		    end
		    
		    def tick
		      top.tick
		    end

		    def clear_cache
		      cache_hash {}
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

		    def payload
		      raise NotImplemented
		    end

		    def trigger_active? trigger, time
		      tmp = instance_exec(time, &trigger)

		      if Fixnum === tmp || Float === tmp
		        0 == tmp
		      else
		        tmp
		      end
		    end

		    def events force: false
		      (force || active?) ? (payload + super(force: true)) : []
		    end
		    
		    def active? 
		      # puts "#{" "*depth}(CB) #{self}.active? #{time}"

		      return false unless super
		      return true if on? or (notes.empty? && triggers.empty?)

		      fires_now = cache[time] ||= begin
		        if triggers.any? do |t|
		          trigger_active? t, time
		        end
		          ! untriggers.any? do |t|
		            trigger_active? t, time
		          end
		        end
		      end
		    end
		  end
		end
	end
end