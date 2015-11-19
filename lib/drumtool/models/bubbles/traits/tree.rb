module DrumTool
  module Models
    class Bubbles
      module Traits
        module Tree
          def self.included base
            base.instance_eval { attr_reader :parent }
            base.array_bubble_attr :children, singular: nil
            base.bubble_attr :child_type, default: nil
          end

          ################################################################################
          # Initializer
          ################################################################################
                  
          def initialize parent = nil, *a
#            puts "#{self} TREE INITIALIZE(#{parent}, #{a.inspect})"
            super *a
            raise ArgumentError, "No blocks." if block_given?
            parent.children << self if Instance === parent  
            @parent = parent
          end

          ################################################################################
          # Stringification
          ################################################################################

          def inspect
            short_name = /[A-Za-z]+$/.match(self.class.name)[0]
            "#<#{short_name}:0x#{(self.object_id << 1).to_s(16).rjust(8, "0")[8..15]} @depth=#{depth}>".rjust(14, "0")
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
          
          def ancestors # flat array
            __ancestors__.tap do |ary|
              ary.shift
            end
          end

          def depth
            ancestors.count
          end

          def root?
            parent.nil?
          end

          def root
            __ancestors__.last
          end

          def descendants # flat array
            [ self, *children.map(&:descendants) ].flatten 1
          end
          
          def branch?
            children.any?
          end
                    
          def branches # flat array
            descendants.select &:branch?
          end

          def leaf?
            children.empty?
          end

          def leaves # flat array
            descendants.select &:leaf?
          end

          ################################################################################

          def child *a
            raise ArgumentError, "No blocks" if block_given?
			  	  (child_type || self.class).new(self, *a)
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
