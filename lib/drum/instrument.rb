require_relative "../dsl_attrs"
require_relative "formatters"

class Drum
  class Instrument
    extend DslAttrs

    dsl_toggle :mute
    dsl_toggle :flip

    dsl_attr :note

		dsl_attr :rot, failover: :collection
    dsl_attr :shift,  failover: :collection
    dsl_attr :loop,   failover: :collection

    attr_reader :name
    attr_reader :short_name
    attr_reader :collection

    def initialize collection, name
      @name, @note, @short_name, @mute, @flip = name, note, name[0..1].upcase, false, false
      @collection, @__triggers__, @__muted_by__ = collection, [], []
      clear_cache
    end

    def build &b
      instance_eval &b
      self
    end

    def clear_cache
      @__cache__ = {}
    end

    def muted_by *names
      names.each do |name|
        raise ArgumentError, "Circular reference while muting '#{name}' by #{sibling(name).name}" if sibling(name).muted_by?(self)
        @__muted_by__ << name
      end
    end

    def muted_by? instr
      @__muted_by__.include? (Instrument === instr ? instr.name : instr)
    end

    def siblings
      @collection.values
    end

    def sibling name 
      @collection[name]
    end

    def mutes *names
      names.each do |name|
        sibling(name).muted_by name
      end
    end

    def on *args, &condition
     clear_cache

		 if args.any?
		 	 fixnums, args = args.partition do |arg|
		 	   Fixnum === arg
		 	 end
		 
		 	 procs, others = args.partition do |arg|
		 	   Proc === arg
		 	 end

		 	 raise ArgumentError, "Invalid argument: #{others.first.class.name} `#{others.first.inspect}'." if others.any?

			 if fixnums.count == 1
				 on do |t|
				   fixnums.first == t
				 end
			 elsif fixnums.count > 1
				 on do |t|
					 [fixnums].include? t
				 end
			 end

		 	 procs.each do |proc|
			   on &proc
			 end
		 end

     @__triggers__ << condition if block_given?
    end

    def fires_at? time
      return false if @mute || (siblings.find do |i|
        muted_by?(i) && i.fires_at?(time)
      end)

			e_time = time
			e_rot = rot || 0
			e_shift = shift || 0

			if loop
			  e_rot %= loop
				e_shift %= loop
			end

			e_time -= e_rot
      e_time %= loop if loop
			e_time -= e_shift
      
      r = @__cache__[e_time] ||= @__triggers__.find do |t|
        tmp = t.call e_time

        if Fixnum === tmp
          0 == tmp
        else
          tmp
        end
      end

      @flip ? (! r) : r
      
    end

    def to_s range = 0..15, formatter = Formatters::BasicInstrumentFormatter, *a
      if formatter
        instance_exec range, *a, &formatter
      else
        super
      end
    end
  end  
end