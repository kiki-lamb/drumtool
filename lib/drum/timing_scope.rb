require_relative "../dsl_attrs"

class Drum
  module TimingScope
    extend DslAttrs

		attr_reader :parent
		attr_accessor :subscopes

		def instruments
		  @instruments ||= Instruments.new(self)
    end

		def triggers_at time
      ( (instruments.values.select do |i|
           i.fires_at? time
         end) +
			  (subscopes.map do |scope|
			     scope.triggers_at time
			   end)).flatten
    end

    def instrument name, note = nil, &b 
      if block_given?
        i = instruments[name]
        i.note note if note
        i.build &b 
      end
    end                   

#		def method_missing? name, *a, &b
#		  if parent.respond_to? name
#				 parent.send(name, *a, &b)
#			else
#				 super
#			end
#		end		

		def initialize p
		  @parent = p
			@rotate, @shift, @loop = 0, 0, nil
			@instruments = nil 
			@subscopes = []
		end

		additive_dsl_attr :rotate, up: :parent
    additive_dsl_attr :shift,  up: :parent
    dsl_attr(         :loop,   up: :parent) do |v|
			0 == v ? nil : v
		end		
  end
end