require_relative "formatters"

class Models
	class Drum
	  class Instrument
	    extend DslAttrs
	    include TimingScope

	    dsl_attr :note, scopable: false

	    attr_reader :name
	    attr_reader :short_name

	    def initialize collection, name
	      @name, @note, @short_name = name, note, name[0..1].upcase
	      @triggers = []
	      @untriggers = []
	      # @__muted_by__ = []
	      super collection
	      clear_cache
	    end

	    def clear_cache
	      @__cache__ = {}
	    end

	#    def muted_by *names
	#      names.each do |name|
	#        raise ArgumentError, "Circular reference while muting '#{name}' by #{sibling(name).name}" if sibling(name).muted_by?(self)
	#        @__muted_by__ << name
	#      end
	#    end
	#
	#    def muted_by? instr
	#      @__muted_by__.include? (Instrument === instr ? instr.name : instr)
	#    end
	#
	#    def siblings
	#      @collection.values
	#    end
	#
	#    def sibling name 
	#      @collection[name]
	#    end
	#
	#    def mutes *names
	#      names.each do |name|
	#        sibling(name).muted_by name
	#      end
	#    end

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

				 instance_variable_get("@#{method_name}s") << condition if condition
	    	end
	    end

	    def to_s range = 0..15, formatter = nil #Formatters::SpacedInstrumentFormatter
	      if formatter
	        instance_exec range,  &formatter
	      else
	        super()
	      end
	    end

	 	  def trigger_fires_at? trigger, time
	     	tmp = trigger.call time

	     	if Fixnum === tmp
	     	  0 == tmp
	     	elsif Float === tmp
	     	  0 == tmp
	     	else
	     	  tmp
	     	end
	    end

	    def fires_at? time
	      throw ArgumentError, "String" if String === time

	      return false if mute?
			
	 #     return false if @mute || (siblings.find do |i|
	 #       muted_by?(i) && i.fires_at?(time)
	 #     end)

	      e_time = time
	#			e_time+=1
	#			e_time /=  repeat

	 
		    e_time = (e_time * (2**(-scale))).to_f

	# 		puts "e_t = #{e_time}"

	      e_rotate = rotate || 0
	      e_shift = shift || 0

	#      if loop
	#        e_rotate %= loop
	#        e_shift %= loop
	#      end

	      e_time -= e_rotate
	      e_time %= loop if loop
	      e_time -= e_shift

	#			puts "e_t2 = #{e_time}"      
				
	      rval = @__cache__[e_time] ||= begin
					if @triggers.any? do |t|
	          trigger_fires_at? t, e_time
	        end
					  ! @untriggers.any? do |t|
	            trigger_fires_at? t, e_time
	          end
				  end
				end

	      tmp = flip? ? (! rval) : rval
	      tmp &&= note
	      tmp
	    end
	  end  
	end
end