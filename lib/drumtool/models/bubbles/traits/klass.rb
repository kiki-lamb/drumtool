module DrumTool
  module Models
	  class Bubbles
      module Traits
		    module Klass
	   		  def bubble_attr name, default: 0, accessor: name, &after		 				
						# Combined getter/setter
	   	      define_method accessor do |v = nil|
              if v
                instance_variable_set("@#{name}", v).tap do
	   	         	  instance_exec(v, &after) if after
	   	          end
              else
                instance_variable_get("@#{name}") or begin
                  instance_variable_set("@#{name}", (default.dup rescue default)).tap do
	   	         	    instance_exec(v, &after) if after
	   	            end
                end
              end
	   	      end
	   	    end

          def adding_bubble_attr name, default: 0, accessor: name, &after
				    bubble_attr "local_#{name}", default: default, &after

					 # Adder-Setter
	   	     define_method accessor do |v = nil|
					   old_v = send("local_#{name}") || default
						 new_v = old_v+v if v
					   send "local_#{name}", new_v						 
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

	   	   def array_bubble_attr name, singular: name.to_s.sub(/s$/, ""), &after
	   	     bubble_attr "#{name}_array", default: nil

		 				# Getter
	   	     define_method name do 
	   	       send("#{name}_array") || send("#{name}_array", [])
	   	     end

		 				# Adder
	   	     define_method singular do |v|
	   	         send(name).tap do |a|
	   	           exists = a.include? v
	   	           a << v unless exists
	   	           instance_exec(v, ! exists, &after) if after
							 end
	   	     end if singular
	   	   end

	   	   def hash_bubble_attr name, singular: name.to_s.sub(/s$/, ""), flip: false, permissive: false, &after
	   	     bubble_attr "#{name}_hash", default: {}

	   	     raise ArgumentError, "permissive can only be used with flip" if permissive && ! flip

		 				# Getter
	   	     define_method name do 
	   	       send("#{name}_hash") || send("#{name}_hash", {})
	   	     end
		 				
		 			 #Adder
	   	     define_method singular do |k, v = nil|
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

	   	   def cumulative_bubble_attr name, default: 0, &after
	   	     bubble_attr name, default: default, accessor: "local_#{name}", &after

		 				# Getter
	   	     define_method name do |v = nil|
	   	         send("local_#{name}", v) + (parent ? parent.send(name) : 0)
	   	     end
	   	   end

	   	   def bubble_toggle name, getter_name: name, setter_name: name, &after
	   	     bubble_attr name, default: false, accessor: "local_#{name}", &after       

		 				# Enabler
	   	     define_method "#{setter_name}!" do |v = nil|
	   	         send("local_#{name}", true)
	   	         nil
	   	     end

		 				# Getter
	   	     define_method "#{getter_name}?" do |v = nil|
	   	       send("local_#{name}") 
	   	     end
	   	   end

	   	   def proximal_bubble_toggle name, &after
	   	   	 bubble_toggle name, getter_name: "local_#{name}", &after

		 		 	 # Getter
	   	   	 define_method "#{name}?" do |v = nil|
	   	   	   send("local_#{name}?") || 
	   	   	   ( parent && parent.respond_to?("#{name}?") && parent.send("#{name}?"))
	   	   	 end
	   	    end
      end
    end
  end
end
end
