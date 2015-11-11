class Drum
  class Bubble
    class << self
			def local_bubble_attr name, default: 0, accessor: name, &after
			  define_method accessor do |v = nil|
						(
						instance_variable_set("@#{name}", v).tap do
					    after.() if after
				   	end if v
						) ||
						instance_variable_get("@#{name}") || 
						default
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
				end

			  define_method "#{getter_name}?" do |v = nil|
				  send("local_#{name}") 
				end
			end

			def bubble_toggle name, &after
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

		local_bubble_attr :loop, default: nil

		bubble_toggle :mute
		bubble_toggle :flip
		
		cumulative_bubble_attr :rotate
		cumulative_bubble_attr :shift
		cumulative_bubble_attr :scale

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
		  @parent, @children = parent, []
		end

    def method_missing name, *a, &b
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
		  Bubble.new(self).build &b
		end

		def build &b
      instance_eval &b
      self
		end
	end
end