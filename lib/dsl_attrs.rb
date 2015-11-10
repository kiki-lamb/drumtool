module DslAttrs
  def dsl_attr name, after: [], failover: nil, default: nil
      define_method(name) do |v = nil, &b|
        if v  
          tmp = instance_variable_get("@#{name}")

          instance_variable_set "@#{name}", v
          [*after].each do |after|
            send after
          end
        end

        tmp = instance_variable_get("@#{name}")

        if tmp
        elsif failover
          tmp = send(failover).send(name, v)
        end

        tmp || default
      end
  end

	def additive_dsl_attr name, up: nil, after: [], &block
			transformer = block

      define_method(name) do |v = nil, &b|
        if v  
          tmp = instance_variable_get("@#{name}")

          instance_variable_set "@#{name}", v
          [*after].each do |after|
            send after
          end
        end

				left = (instance_variable_get("@#{name}") || 0)
				up_obj = send(up)
				fetched = up_obj ? up_obj.send(name) : 0
				right = (up ? (fetched || 0) : 0)

        tmp = left + right
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
