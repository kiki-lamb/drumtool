require_relative "../dsl_attrs"

class Drum
  module TimingScope
    extend DslAttrs

		attr_reader :parent

		def instruments
		  @instruments ||= Instruments.new(self)
    end

    def instrument name, note = nil, &b 
      if block_given?
        i = instruments[name]
        i.note note if note
        i.build &b 
      end
    end                   

		def initialize p
		  @parent = p
			@rotate, @shift, @loop = 0, 0, nil
			@instruments = nil 
		end

		additive_dsl_attr :rotate, up: :parent
    additive_dsl_attr :shift,  up: :parent
    dsl_attr(         :loop,   up: :parent) do |v|
			0 == v ? nil : v
		end		
  end
end