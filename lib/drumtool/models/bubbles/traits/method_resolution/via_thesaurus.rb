require "set"

module DrumTool
  module Models
    class Bubbles
      module Traits
        module MethodResolution
          module ViaThesaurus
          IGNORED_METHODS = Set[:__send__, :object_id, :__id__, :==, :equal?,
                                :'!', :'!=', :instance_exec, :instance_variables,
                                :instance_variable_get, :instance_variable_set,
                                :remove_instance_variable,
                                :abbreviate, :synonimize, :expand, :__thesaurus__ ]

          def self.included base
            base.extend ClassMethods
          end
          
          def self.prepended base
            included base
          end
          
          module ClassMethods
            def abbreviate *a, **o
              raise ArgumentError, "Use 'synonymize' to add synonyms." unless o.empty?
              a = Array [*a].flatten 1 if a.any?
              __thesaurus__.abbreviate *a
            end
            
            def synonymize meth, as
            __thesaurus__.abbreviate meth => as
            end
            
            def expand name
              (__thesaurus__[name] || name) rescue name
            end
          
            def __thesaurus__
              @__thesaurus__ ||= Preprocessors::Thesaurus.new
            end
          end

          def method_missing name, *a, &b
            puts "#{self} MISSING VT: #{name}"
            exp = self.class.expand name
            if respond_to? exp
              send(exp, *a, &b)
            else
              super name, *a, &b
            end
          end

          def respond_to? name, all = false
            #            name = self.class.expand name unless __the_name_is_pre_expanded__
            puts "#{self} RESPOND VT: #{name}"
            super(name, all)
          end
        end
      end
    end
  end
end
end
