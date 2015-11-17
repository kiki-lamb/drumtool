module DrumTool
  module Models
    class LighterBubbles
      class Base
       attr_reader :parent
       array_bubble_attr :children, singular: nil

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
#				 puts "(P)#{parent} << (C)#{self}" if parent
         @parent = parent
				 build(&b) if b
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

       def bubble *a, &b
				 o = self.class.new(self, *a)
#				 puts "B#{self} builds child #{o}"
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