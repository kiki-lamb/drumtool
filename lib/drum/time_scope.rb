require_relative "../dsl_attrs"

class Drum
  class TimeScope
    extend DslAttrs

	  attr_accessor :up

		additive_dsl_attr :rotate, up: :up
    additive_dsl_attr :shift,  up: :up
    additive_dsl_attr(:loop,   up: :up) do |v|
			0 == v ? nil : v
		end		

	  def __initialize__ up = nil
		  @up = up
		end

  end
end