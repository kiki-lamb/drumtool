module DrumTool
  module Models
	  class Bubbles
		  class Base
        class << self
				  def bubble *a, &b
	   	      o = new(*a)
						o.build(&b)
	   	   	end

					def bubble_scope obj, accessor, *v, &b
		 				obj.bubble do 
		 				  send accessor, *v
		 				end.build &b					
					end

	   		  def bubble_attr name, default: 0, accessor: name, &after		 				
						# Combined getter/setter
	   	      define_method accessor do |v = nil, &b|
		 				    if b
								  self.class.bubble_scope self, accessor, v, &b
		 						else				
	   	         	(
	   	         	  (
	   	         	    instance_variable_set("@#{name}", v).tap do
#										  puts "#{self}.#{name} = #{v.class.name} `#{v.inspect}'"
	   	         	      instance_exec(v, &after) if after
	   	         	    end if v
	   	         	  ) ||
	   	         	  instance_variable_get("@#{name}") || 
	   	         	  default
	   	         	) # .tap do |v|
	   	         	  # puts "#{self.class.name}.#{name} returns #{v.class.name} `#{v}'."
	   	         # end
		 					end
	   	      end
	   	   end

				 def adding_bubble_attr name, default: 0, accessor: name, &after
				   bubble_attr "local_#{name}", default: default, &after

					 # Adder-Setter
	   	     define_method accessor do |v = nil, &b|
					   old_v = send("local_#{name}") || default
						 new_v = old_v+v if v
					   send "local_#{name}", new_v, &b						 
					 end
				end

	   	   def counter_bubble_attr name, default: 0, return_value: name, before: nil, after: nil
	   	     bubble_attr name, default: default
	   	     
		 				# Incrementer
	   	     define_method "#{name}!" do
	   	       self.send before if before

	   	       self.send(return_value).tap do
	   	         self.send name, self.send(name) + 1
	   	         self.send after if after
	   	       end
	   	     end
	   	   end

	   	   def array_bubble_attr name, singular: name.to_s.sub(/s$/, ""), uniq: false, scopable: true, &after
	   	     bubble_attr "#{name}_array", default: nil

		 				# Getter
	   	     define_method name do 
	   	       send("#{name}_array") || send("#{name}_array", [])
	   	     end

		 				# Adder
	   	     define_method singular do |v, &b|
					   if b
						   raise ArgumentError, "Not scopable" unless scopable
						 	 self.class.bubble_scope self, singular, v, &b
						 else
	   	         send(name).tap do |a|
	   	           exists = a.include? v
	   	           a << v unless exists
	   	           instance_exec(v, ! exists, &after) if after
							 end
	   	       end
	   	     end if singular
	   	   end

	   	   def hash_bubble_attr name, singular: name.to_s.sub(/s$/, ""), flip: false, permissive: false, uniq: false, &after
	   	     bubble_attr "#{name}_hash", default: nil

	   	     raise ArgumentError, "permissive can only be used with flip" if permissive && ! flip

		 				# Getter
	   	     define_method name do 
	   	       send("#{name}_hash") || send("#{name}_hash", {})
	   	     end
		 				
		 			 #Adder
	   	     define_method singular do |k, v = nil, &b|
					   if b
						 	 self.class.bubble_scope self, singular, v, &b
						 else
	   	       	 if flip
	   	       	    k, v = v, k

	   	       	    if permissive and k.nil?
	   	       	      k, v = v, k
	   	       	    end
	   	       	 end       

	   	         send(name).tap do |h|
	   	           h[k] = v
	   	           instance_exec(v, &after) if after
							 end
	   	       end
	   	     end
	   	   end

	   	   def cumulative_bubble_attr name, default: 0, &after
	   	     bubble_attr name, default: default, accessor: "local_#{name}", &after

		 				# Getter
	   	     define_method name do |v = nil, &b|
					   if b
						   self.class.bubble_scope self, name, v, &b
						 else
	   	         send("local_#{name}", v) + (parent ? parent.send(name) : 0)
						 end
	   	     end
	   	   end

	   	   def bubble_toggle name, getter_name: name, setter_name: name, &after
	   	     bubble_attr name, default: false, accessor: "local_#{name}", &after       

		 				# Enabler
	   	     define_method "#{setter_name}!" do |v = nil, &b|
					   if b
						   self.class.bubble_scope self, "#{setter_name}!", v, &b
						 else
	   	         send("local_#{name}", true)
	   	         nil
             end
	   	     end

		 				# Getter
	   	     define_method "#{getter_name}?" do |v = nil|
	   	       send("local_#{name}") 
	   	     end
	   	     end

	   	   	 def proximal_bubble_toggle name, &after
	   	   	   bubble_toggle name, getter_name: "local_#{name}", &after

		 		 	 # Getter
	   	   	 define_method "#{name}?" do |v = nil, &b|
	   	   	   send("local_#{name}?", &b) || 
	   	   	   ( parent && parent.respond_to?("#{name}?") && parent.send("#{name}?"))
	   	   	 end
	   	    end
        end
      end
    end
  end
end
