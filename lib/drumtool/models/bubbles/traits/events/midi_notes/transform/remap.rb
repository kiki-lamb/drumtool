module DrumTool
  module Models
    class Bubbles
      module Traits
        module Events
          module MIDINotes
              module Transform
              module Remap
                # Relies upon Transform.
                
                def remap! *a
                  unless [2, 12].include? a.count
                    raise ArgumentError, "Pass 2 or 12 arguments"
                  end

                  @@cache ||= {}
                  transfer_mappings = {}
                  
                  if a.count == 2
                    transfer_mappings[a.first] = a.last
                  elsif a.count == 12
                    a.each_with_index do |out_note, in_note|
                      transfer_mappings[in_note] = out_note
                    end
                  end

                  xform do |note|
                    note.number = ( @@cache[[a,note.number]] ||= begin
                                                                  #o = note.number
                                                                  pitch_class = note.number % 12
                                                                  floor = note.number-pitch_class
                                                                  
                                                                  if transfer_mappings.include? pitch_class
                                                                    o = note.number
                                                                    t = floor + transfer_mappings[pitch_class]
                                                                    #puts "REMAP #{o} => #{t}"
                                                                    t
                                                                  else
                                                                    note.number
                                                                  end
                                                             end )                    
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

