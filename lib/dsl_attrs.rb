
module DslAttrs
	def __dsl_attr_scopified__ self_, name, v, scopable, &block_
	  raise "#{self_.class.name}.#{name} is not scopable" unless scopable
		@@__dsl_attr_scope_klass__ ||= Class.new { include Drum::TimingScope }
		obj = @@__dsl_attr_scope_klass__.new self_
		self_.subscopes << obj
		obj.send name, v
		obj.build &block_	 
	end

  def dsl_attr name, after: [], up: nil, default: nil, scopable: true, &block
	    transformer = block

      define_method(name) do |v = nil, &block_|
			  if block_				  
					self.class.__dsl_attr_scopified__ self, name, v, scopable, &block_
				else 
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
  end

	def additive_dsl_attr name, up: nil, after: [], scopable: true, &block
			transformer = block

      define_method(name) do |v = nil, &block_|
			  if block_
					self.class.__dsl_attr_scopified__ self, name, v, scopable, &block_
        else 
        	if v  
        	  instance_variable_set "@#{name}", v
        	  [*after].each do |after|
        	    send after
        	  end
        	end

					up_obj = send(up) if up

        	tmp = (instance_variable_get("@#{name}") || 0) + ((up_obj ? up_obj.send(name) : 0) || 0)
					tmp = transformer.call tmp if transformer
					tmp
        end
      end
  end

  def dsl_toggle name, up: nil
      define_method(name) do |v = true, &b_|
			    if b_
						 self.class.__dsl_attr_scopified__ self, name, v, true, &b_					  
          else
					  instance_variable_set "@#{name}", v
          end
      end

      define_method("#{name}?") do
          t = instance_variable_get ("@#{name}" || false)

					unless t
					  up_obj = send(up) if up
						t ||= (up_obj.send("#{name}?") || false) if up_obj
					end

					t
      end
  end
end
