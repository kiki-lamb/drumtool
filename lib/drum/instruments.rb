require_relative "../dsl_attrs"

class Drum
  class Instruments < Hash
    extend DslAttrs

    attr_reader :engine

    # We never actually enter a DSL on this class an are really just using these as 'delegate_to'.
    dsl_attr :shift, failover: :engine
    dsl_attr:loop , failover: :engine

    def initialize engine, *a
      @engine = engine

      super(*a) do |h,k| 
        h[k] = Instrument.new self, k
      end   
    end

    def to_s
      "{#{keys.map do |k| 
        "#{k}=>#{self[k]}"
      end.join ", "}}"
    end   

    def [] k
      super k.to_sym
    end

    def []= k, v
      super k.to_sym, v
    end

    def include? k
      super k.to_sym
    end
  end
end