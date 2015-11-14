module DrumTool
	module Models
	  module Basic
	    class Formatters
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

	      BasicInstrumentFormatter = Proc.new do |range|
	        range.map do |t| 
	          puts "#{self.class.name}(#{name}) before fires_at? #{t.class.name} `#{t}'"
	          t = fires_at?(t) ? name[0].upcase : "." 
	          puts "#{self.class.name}(#{name}) after fires_at?"
	          t
	        end.join
	      end

	      SpacedInstrumentFormatter = Proc.new do |range|
	        TableRowFormatter.call(to_s(range, BasicInstrumentFormatter).chunks(4), separator: ' ')
	      end

	      BasicEngineFormatter = Proc.new do |range|
	        instruments.map do |k, v|
	          "#{v.name}: #{v.to_s range, InstrumentFormatter}"
	        end.join "\n"
	      end 

	      BasicTableEngineFormatter = Proc.new do |range|
	        BasicTableFormatter.call(    
	          instruments.map do |k, v|
	            [ v.name, *v.to_s(range, SpacedInstrumentFormatter).strip.chunks(20) ]    
	          end    
	        )
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

	      MultiTableEngineFormatter = Proc.new do |range|
	          puts "#{self.class.name} before make body"
	          body = instruments.values.map do |v|
	            [ v.short_name, *v.to_s(range, SpacedInstrumentFormatter).strip.chunks(20) ]
	  #          [ v.short_name ]
	          end    
	          puts "#{self.class.name} after make body"

	          fill = TableRowFormatter.call((0..15).map do |x| 
	            x.to_s 16 
	          end.join.chunks(4), separator: ' ')

	          head = RuleredHeaderBuilder.call body

	          head[0].each_with_index do |_, ix|
	            next if 0 == ix
	            head[0][ix] = TableRowFormatter.call (((ix%16)-1).to_s(16) * 16).chunks(4), separator: ' '
	          end

	          head[1].map! do
	            fill      
	          end

	          head[1][0] = nil

	          MultiTableFormatter.call [ head, body ]
	      end
	    end
	  end
	end
end