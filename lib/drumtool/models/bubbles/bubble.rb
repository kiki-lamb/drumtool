module DrumTool
  module Models
    module Bubbles
      class Bubble
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

       def initialize parent = nil
         parent.children << self if Bubble === parent  
         @parent = parent
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

       def bubble &b
         self.class.new(self).build(&b)
       end

       def build &b
         instance_eval &b
         self
       end
     end
    end
  end
end