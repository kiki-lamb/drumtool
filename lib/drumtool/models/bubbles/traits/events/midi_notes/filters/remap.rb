module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
            module Filters
              module Remap
                def self.prepended base
                  base.hash_bubble_attr :transfer_mappings
                end

                def remap *a
                  unless [2, 12].include? a.count
                    raise ArgumentError, "Pass 2 or 12 arguments"
                  end

                  if a.count == 2
                    transfer_mappings[a.first] = a.last
                  elsif a.count == 12
                    a.each_with_index do |out_note, in_note|
                      transfer_mappings[in_note] = out_note
                    end
                  end
                end

                def __remap_note__ note

                  pitch_class = note.number % 12
                  floor = note.number-pitch_class

                  if transfer_mappings.include? pitch_class
                    o = note.number
                    note.number = floor + transfer_mappings[pitch_class]
#                    puts "#{o} => #{note.number}"
                  end
                end
                
                def events
                  return super if transfer_mappings.empty?
                  
                  super.map(&:dup).each do |evt|
                    __remap_note__ evt
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
