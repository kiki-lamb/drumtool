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

				l = (instance_variable_get("@#{name}") || 0)
				up_obj = send(up)
				fetched = up_obj ? up_obj.send(name) : 0
				r = (up ? (fetched || 0) : 0)

				puts "l = #{l.class.name} `#{l}'"
				puts "up_obj = #{up_obj.class.name} `#{up_obj}'"
				puts "`#{name}' fetched = #{fetched.class.name} `#{fetched}'"
				puts "r = #{r.class.name} `#{r}'"

        t = l + r 
				t = transformer.call t if transformer
				# puts "#{self.class.name}.#{name} returns #{t.class.name} `#{t}'."
				t
      end
  end

  def dsl_toggle name
      define_method(name) do
          instance_variable_set "@#{name}", true
      end
  end
end
