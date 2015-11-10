module DslAttrs
  def dsl_attr name, after: [], up: nil, default: nil, &block
	    transformer = block

      define_method(name) do |v = nil|
        if v  
          instance_variable_set "@#{name}", v
          [*after].each do |after|
            send after
          end
        end

        tmp = instance_variable_get "@#{name}"

        if (! tmp) && up
				  up_obj = send up
          tmp = up_obj.send(name, v) if up_obj
        end

        tmp ||= default
				tmp = transformer.call tmp if transformer
				tmp
      end
  end

	def additive_dsl_attr name, up: nil, after: [], &block
			transformer = block

      define_method(name) do |v = nil, &b|
        if v  
          instance_variable_set "@#{name}", v
          [*after].each do |after|
            send after
          end
        end

				up_obj = send(up)

        tmp = (instance_variable_get("@#{name}") || 0) + ((up_obj ? up_obj.send(name) : 0) || 0)
				tmp = transformer.call tmp if transformer
				tmp
      end
  end

  def dsl_toggle name
      define_method(name) do
          instance_variable_set "@#{name}", true
      end
  end
end
