require_relative "../dsl_attrs"

class Drum
  module TimingScope
    extend DslAttrs

		attr_accessor :parent

		def initialize p
		  @parent = p
			@rotate, @shift, @loop = 0, 0, nil
		end

		additive_dsl_attr :rotate, up: :parent
    additive_dsl_attr :shift,  up: :parent
    additive_dsl_attr(:loop,   up: :parent) do |v|
			0 == v ? nil : v
		end		
  end
end