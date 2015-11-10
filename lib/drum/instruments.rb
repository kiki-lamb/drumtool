require_relative "../dsl_attrs"

class Drum
  class Instruments
    extend DslAttrs

    attr_reader :engine

    # We never actually enter a DSL on this class an are really just using these as 'delegate_to'.

    additive_dsl_attr :rotate, up: :engine
    additive_dsl_attr :shift,  up: :engine
    additive_dsl_attr(:loop ,  up: :engine) do |v|
			0 == v ? nil : v
		end		

    def initialize engine
      @engine = engine

      @__hash__= Hash.new do |h,k| 
        h[k] = Instrument.new self, k
      end   
    end

    def to_s
      "{#{keys.map do |k| 
        "#{k}=>#{self[k]}"
      end.join ", "}}"
    end   

    def [] k
      @__hash__[k.to_sym]
    end

    def []= k, v
      @__hash__[k.to_sym] = v
    end

    def include? k
		  @__hash__.include? k.to_sym
    end

		def values
		  @__hash__.values
		end
  end
end