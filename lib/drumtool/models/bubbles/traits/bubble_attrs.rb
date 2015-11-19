module DrumTool
  module Models
    class Bubbles
      module Traits
        module BubbleAttrs
          module ClassMethods
            def bubble_attr name, default: 0, accessor: name, &after            
              # Combined getter/setter
              define_method accessor do |v = nil|
                if v
                  send "__#{accessor}__", v
                else
                  instance_variable_get("@#{name}") or send("__#{accessor}__", (Module === default ? default : (default.dup rescue default)))
                end
              end
              
              define_method "__#{accessor}__" do |v|
                instance_variable_set("@#{name}", v).tap do
                  instance_exec(v, &after) if after
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
          
            def counter_bubble_attr name, default: 0, return_value: name, before: nil, incrementor: "#{name}!", reversor: "reverse_#{name}!", increment: 1, after: nil
              bubble_attr name, default: default
              bubble_attr "#{name}_increment", default: increment
              
              # Incrementer
              define_method incrementor do
                self.send before if before
                
                t = self.send name, self.send(name) + send("#{name}_increment")
                self.send after if after
                t
              end

              # Reverse clock direction
              define_method reversor do
                self.send "#{name}_increment", -self.send("#{name}_increment")
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
          
            def hash_bubble_attr name, singular: name.to_s.sub(/s$/, ""), flip: false, permissive: false, default: {}, &after
              bubble_attr "#{name}_hash", default: default
              
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
                  instance_exec(k, v, &after) if after
                end
              end
            end
          
            def bubble_toggle name, getter_name: name, setter_name: name, &after
              bubble_attr name, default: false, accessor: "local_#{name}", &after       
              
              # Enabler
              define_method "#{setter_name}!" do |v = nil|
                send("local_#{name}", true)
              end
              
              # Getter
              define_method "#{getter_name}?" do |v = nil|
                !! send("local_#{name}") 
              end
            end
          end

          def self.included base
            base.extend ClassMethods
          end
        end
      end
    end
  end
end
  
