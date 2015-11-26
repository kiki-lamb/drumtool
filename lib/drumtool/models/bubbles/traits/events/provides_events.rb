module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module ProvidesEvents
            as_trait do |events_accessor, *provided_klasses|
              define_method :events do |*requested_klasses|
                # Bail if we don't provide anything or nothing was requested.
                return super(*requested_klasses) if provided_klasses.empty? || requested_klasses.empty?
                
                permitted_klasses = requested_klasses.select do |rklass|
                  provided_klasses.any? do |pklass|
                    pklass.ancestors.include? rklass
                  end
                end

                # Bail if there's no intersection between what was requested and what's provided.
                return super(*requested_klasses) if permitted_klasses.empty?
                
                super(*requested_klasses).dup.tap do |s|                                    
                  s.push *send(events_accessor).select do |evt|
                    permitted_klasses.any? do |klass|
                      klass === evt
                    end
                  end                                   
                end                
              end
            end
          end
        end
      end
    end
  end
end

