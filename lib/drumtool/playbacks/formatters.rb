module DrumTool
  module Playbacks
  module Formatters
    BasicTableFormatter = Proc.new do |rows|
      raise ArgumentError, "Uneven rows" unless rows.map(&:count).uniq.length == 1
      
      padded = rows.map do |r| 
        r.map! do |c| 
          " #{c.to_s.strip} " 
        end
      end
      
      widths = padded.map do |r| 
        r.map do |c| 
          c.to_s.length
        end
      end.inject do |l,r| 
        l.zip(r).map do |a| 
          a.max
        end
      end
      
      spacer = TableRowFormatter.call(widths.map do |w| 
                                        "=" * w 
                                      end, widths, separator: '+')
      
      [ spacer,
        rows.map do |row|
          TableRowFormatter.call row, widths
        end,
        spacer
      ].join "\n"
    end
    
    MultiTableFormatter = Proc.new do |rowses| 
      raise ArgumentError, "Uneven rows" unless rowses.flatten(1).map(&:count).uniq.length == 1
      
      padded = rowses.map do |r| 
        r.map do |a| 
          a.map! do |c| 
            " #{c.to_s.strip} "
          end
        end
      end
      
      widths = padded.flatten(1).map do |r| 
        r.map do |c| 
          c.to_s.length 
        end 
      end.inject do |l,r| 
        l.zip(r).map do |a| 
          a.max
        end
      end
      
      spacer = TableRowFormatter.call(widths.map do |w| 
                                        "=" * w 
                                      end, widths, separator: '+')
      
      [ 
        *padded.map do |rows|
          [ spacer,
            rows.map do |row|
              TableRowFormatter.call row, widths
            end
          ]
        end,
        spacer
      ].join "\n"
    end
    
    TableRowFormatter = Proc.new do |values, widths = [], separator: "|"|
                                                          "#{separator}#{values.each_with_index.map do |value, ix|
            value.to_s.ljust(widths[ix] || value.to_s.length)
          end.join "#{separator}" }#{separator}"
    end
                                     
    BasicHeaderBuilder = Proc.new do |lines, body|
        lines.times.map do
           body.first.length.times.map do 
             ""
          end
        end 
    end

    RuleredHeaderBuilder = Proc.new do |body|
       empty = BasicHeaderBuilder.call 2, body
    end

    end
  end
end
