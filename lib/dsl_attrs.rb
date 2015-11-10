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

        t = (instance_variable_get("@#{name}") || 0) + (up ? (send(up).send(name) || 0) : 0)
				t = transformer.call t if transformer
				t
      end
  end

  def dsl_toggle name
      define_method(name) do
          instance_variable_set "@#{name}", true
      end
  end
end
