require_relative "../dsl_attrs"

class Drum
  class Instruments
    extend DslAttrs

		include TimingScope

    attr_reader :engine

    def initialize engine
      @engine = engine
			super @engine

      @__hash__= Hash.new do |h,k| 
        h[k] = Instrument.new self, k
      end   
    end

#    def to_s
#      "{#{keys.map do |k| 
#        "#{k}=>#{self[k]}"
#      end.join ", "}}"
#    end   

		def keys
		  @__hash__.keys
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

		#def map &b
		#  @__hash__.map &b
		#end

		def values
		  @__hash__.values
		end
  end
end