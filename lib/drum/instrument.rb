require_relative "../dsl_attrs"
require_relative "formatters"

class Drum
  class Instrument
    extend DslAttrs

    dsl_toggle :mute
    dsl_toggle :flip

    dsl_attr :note
    dsl_attr :shift, failover: :collection
    dsl_attr :loop, failover: :collection

    attr_reader :name
    attr_reader :short_name
    attr_reader :collection

    def initialize collection, name
      @name, @note, @loop, @shift, @short_name, @mute, @flip = name, note, nil, nil, name[0..1].upcase, false, false
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
        raise ArgumentError, "Circular reference while muting" if sibling(name).muted_by?(self)
        @__muted_by__ << name
      end
    end

    def muted_by? instr
      @__muted_by__.include? (Instrument === instr ? instr.name : instr)
    end

    def sibling name 
      @collection[name]
    end

    def mutes *names
      names.each do |name|
        sibling(name).muted_by name
      end
    end

    def on &condition
     clear_cache
     @__triggers__ << condition
    end

    def fires_at? time
      return false if @mute || (@collection.values.find do |i|
        muted_by?(i) && i.fires_at?(time)
      end)

      e_time = time - ( shift || 0 )
      e_time %= loop if loop
      
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