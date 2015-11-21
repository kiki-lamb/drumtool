module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
        module Triggered
        def self.prepended base 
          base.hash_bubble_attr :cache, singular: :add_cache
          base.hash_bubble_attr :ucache, singular: :add_ucache
          base.proximal_bubble_toggle :flip
          base.bubble_toggle :force
          base.array_bubble_attr :triggers, singular: :add_trigger do |v|
            clear_caches
          end

          base.array_bubble_attr :untriggers, singular: :add_untrigger do |v|
            clear_caches
          end
        end

        def events
          super if active?
        end

        def clear_caches
          ucache_hash {}
          cache_hash {}
        end
        
        %i{ trigger untrigger }.each do |method_name|
          define_method method_name do |*args, &condition|
            if args.any?
              ranges, args = args.partition do |arg|
                Range === arg
              end
              
              fixnums, args = args.partition do |arg|
                  Fixnum === arg
              end
              
              procs, others = args.partition do |arg|
                Proc === arg
              end
              
              raise ArgumentError, "Invalid argument: #{others.first.class.name} `#{others.first.inspect}'." if others.any?
              
              if fixnums.count == 1
                send method_name  do |t|
                  fixnums.first == t
                end
              elsif fixnums.count > 1
                send method_name do |t|
                  fixnums.include? t
                end
              end
              
              ranges.each do |range|
                send method_name do |t|
                  range.include? t
                end
              end
              
              procs.each do |proc|
                send method_name, &proc
              end
            end
            
            send("add_#{method_name}", condition) if condition
          end
        end
        
        def active?
          (force? or (notes.empty? && triggers.empty?)) or begin          
                                                          fires_now = cache[time] ||= triggers.any? do |t|
                                                            trigger_active? t, time
                                                          end

                                                          canceled_now = ucache[time] ||= untriggers.any? do |t|
                                                            trigger_active? t, time
                                                          end
                                                          
                                                          t = (fires_now && ! canceled_now)
                                                          flip?? !t : !!t
                                                        end
        end            

        private
        def trigger_active? trigger, time
          tmp = instance_exec(time, &trigger)

          if Fixnum === tmp || Float === tmp
            0 == tmp
          else
            tmp
          end
        end
      end
      end
    end
  end
end
end

