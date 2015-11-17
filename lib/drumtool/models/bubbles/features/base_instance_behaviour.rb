module DrumTool
  module Models
    class Bubbles
      module BaseInstanceBehaviour
        def self.included base
          base.instance_eval { attr_reader :parent }
          base.array_bubble_attr :children, singular: nil
        end

       def top
         obj = self
         while (next_obj = obj.parent) != nil do
             obj = next_obj 
         end
         obj
       end

       def depth
         ctr = 0

         obj = self
         while (next_obj = obj.parent) != nil do
             ctr += 1
             obj = next_obj 
         end

         ctr
       end

       def initialize parent = nil, &b
         parent.children << self if Base === parent  
         @parent = parent
				 build(&b) if b
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

       def bubble *a, &b
				 o = self.class.new(self, *a)
         o.build(&b)
       end

       def build &b
         instance_eval &b if b
         self
       end
     end
    end
  end
end
