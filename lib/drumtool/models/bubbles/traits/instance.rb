module DrumTool
  module Models
    class Bubbles
      module Traits
        module Instance
          def self.included base
            base.instance_eval { attr_reader :parent }
            base.array_bubble_attr :children, singular: nil
            base.bubble_attr :child_type, default: nil
          end

          ################################################################################
          # Initializer
          ################################################################################
                  
          def initialize parent = nil
            raise ArgumentError, "No blocks." if block_given?
            parent.children << self if Instance === parent  
            @parent = parent
          end

          ################################################################################
          # Stringification
          ################################################################################

          def inspect
            short_name = /[A-Za-z]+$/.match(self.class.name)[0]
            "#<#{short_name}:0x#{(self.object_id << 1).to_s(16).rjust(8, "0")[8..15]} @depth=#{ancestors.count}>".rjust(14, "0")
          end

          def to_s
            inspect
          end

          ################################################################################
          # Tree methods
          ################################################################################
          

          def __ancestors__
            [ self, *(parent.__ancestors__ if parent) ]
          end
          
          def ancestors
            __ancestors__.tap do |ary|
              ary.shift
            end
          end
          
          def leaf?
            children.empty?
          end

          def root
            __ancestors__.last
          end

          def root?
            parent.nil?
          end

          def depth
            ancestors.count
          end

          ################################################################################

          
          ################################################################################
          # Method resolution
          ################################################################################
          
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
			  	  (child_type || self.class).new(self, *a).build(&b)
          end

          def build &b
            instance_eval &b if b
            self
          end
        end
      end
    end
  end
end
