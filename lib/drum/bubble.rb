class Drum
  class Bubble
    class << self
		  def bubble_attr name, default: nil, &after
			  define_method name do |v = nil|
				  ((instance_variable_set "@#{name}", v if v) || instance_variable_get("@#{name}") || default).tap do
					  after.() if after
					end
				end
			end

		  def cumulative_bubble_attr name, default: 0, &after
			  define_method name do |v = nil|
				  (
					  ((instance_variable_set "@#{name}", v if v) || instance_variable_get("@#{name}") || default) +
						(parent ? parent.send(name) : 0)
					).tap do
					  after.() if after
					end
				end
			end

			def bubble_toggle name, &after
			  define_method name do |v = nil|
				  instance_variable_set "@#{name}", true
					after.() if after
					true
				end
			end

			def build &b
			  new.build &b			
			end
    end

		bubble_toggle :mute
		bubble_toggle :flip

		bubble_attr :loop, default: nil
		
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