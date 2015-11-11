require_relative "./musical_bubble"

class Drum
  class ChildBubble < Bubble
	  local_hash_bubble_attr :notes
		local_array_bubble_attr :triggers, singular: :add_trigger
		local_array_bubble_attr :untriggers, singular: :add_untrigger

		proximal_bubble_toggle :flip

		%i{ trigger untrigger }.each do |method_name|
    	define_method method_name do |*args, &condition|
    	 clear_cache

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

			 send("add_#{method_name}") << condition if condition
    	end
    end
  end
end