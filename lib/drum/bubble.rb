class Drum
  class Bubble
    class << self
			def local_bubble_attr name, default: 0, accessor: name, &after
			  define_method accessor do |v = nil|
						(
						  (
							  instance_variable_set("@#{name}", v).tap do
					  	    after.() if after
				   		  end if v
							) ||
							instance_variable_get("@#{name}") || 
							default
						) # .tap do |v|
						  # puts "#{self.class.name}.#{name} returns #{v.class.name} `#{v}'."
						# end
				end
			end

			def local_array_bubble_attr name, singular: name.to_s.sub(/s$/, ""), uniq: false, &after
			  local_bubble_attr "#{name}_array", default: nil

				define_method name do 
				  send("#{name}_array") || send("#{name}_array", [])
				end

				define_method singular do |v|
				  send(name).tap do |a|
					  a << v unless a.include? v
					end
				end 
			end

			def local_hash_bubble_attr name, singular: name.to_s.sub(/s$/, ""), uniq: false, &after
			  local_bubble_attr "#{name}_hash", default: nil

				define_method name do 
				  send("#{name}_hash") || send("#{name}_hash", {})
				end

				define_method singular do |k, v = nil|
				  send(name).tap do |h|
						  h[k] = v
					end
				end
			end

		  def cumulative_bubble_attr name, default: 0, &after
			  local_bubble_attr name, default: default, accessor: "local_#{name}", &after

			  define_method name do |v = nil|
				  send("local_#{name}", v) + (parent ? parent.send(name) : 0)
				end
			end

			def local_bubble_toggle name, getter_name: name, setter_name: name, &after
			  local_bubble_attr name, default: false, accessor: "local_#{name}", &after			  

			  define_method "#{setter_name}!" do |v = nil|
				  send("local_#{name}", true)
					nil
				end

			  define_method "#{getter_name}?" do |v = nil|
				  send("local_#{name}") 
				end
			end

			def proximal_bubble_toggle name, &after
			  local_bubble_toggle name, getter_name: "local_#{name}", &after

			  define_method "#{name}?" do |v = nil|
				  send("local_#{name}?") || 
					( parent && parent.respond_to?("#{name}?") && parent.send("#{name}?"))
				end
			end

			def build &b
			  new.build &b			
			end
    end

		attr_reader :parent
		attr_reader :children

    def top
      obj = self
      while (next_obj = obj.parent) != nil do
          obj = next_obj 
      end
      obj
    end

		def initialize parent = nil
		  parent.children << self if Bubble === parent	
		  @parent, @children = parent, []
		end

    def method_missing name, *a, &b
		  puts "#{self}.method_missing(#{name})"
		  if parent.respond_to?(name)
			  parent.send name, *a, &b
			else
			  super
			end
    end

		def respond_to? name, all = false
		  super(name, all) || (parent && parent.respond_to?(name, all))
		end

		def child &b
		  self.class.new(self).build(&b)
		end

		def build &b
      instance_eval &b
      self
		end
	end
end