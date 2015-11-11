require_relative "../dsl_attrs"

class Drum
  module TimingScope
    extend DslAttrs

    attr_reader :parent
    attr_accessor :subscopes

    def top
      obj = self
      while (next_obj = obj.parent) != nil do
          obj = next_obj 
      end
      obj
    end

    def method_missing name, *a, &b
      parent.send name, *a, &b
    end

    def build &b
      instance_eval &b
      self
    end

    def instruments
      subscopes.map(&:instruments).flatten + @__hash__.values
    end

    def triggers_at time
      instruments.map do |i|
        i.fires_at?(time) || nil
      end.compact
    end

    def instrument name, note = nil, &b 
      if block_given?
        i = @__hash__[name]
        i.note note if note
        i.build &b 
      end
    end                   

    def initialize p
      @parent = p
      @rotate, @shift, @loop = 0, 0, nil
      @instruments = nil 
      @subscopes = []

      @__hash__= Hash.new do |h,k| 
        h[k] = Instrument.new self, k
      end   
    end

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

    dsl_toggle :mute, up: :parent
    dsl_toggle :flip, up: :parent

    additive_dsl_attr :rotate, up: :parent
    additive_dsl_attr :shift,  up: :parent
    dsl_attr(         :loop,   up: :parent) do |v|
      0 == v ? nil : v
    end   
  end
end