module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filter
              module MinMax                
                def range? attr_, rng_or_start = nil, end_ = nil
                  end_, rng_or_start, attr_ = rng_or_start, attr_, :note unless rng_or_start
                  
                  if end_
                    min attr_, rng_or_start
                    max attr_, end_
                  else
                    min attr_, rng_or_start.min
                    min attr_, rng_or_start.max
                  end
                end

                def min? attr_, val = nil
                  val, attr_ = attr_, :note unless val

                  filter do |evt| 
                    evt.send(attr_) >= val
                  end
                end

                def max? attr_, val = nil
                  val, attr_ = attr_, :note_ unless val
                  
                  filter do |evt|
                    evt.send(attr_) <= val
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

