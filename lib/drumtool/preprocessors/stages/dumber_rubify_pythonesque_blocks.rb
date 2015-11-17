module DrumTool
	module Preprocessors
	  module Stages
		  class DumberRubifyPythonesqueBlocks < Base
        class IndentationError < Exception; end
        class BadBlockError < Exception; end

        LinePat = /^(\s*)(>)?\s*(.*)/
        
        def split line
          LinePat.match line
          [ Regexp.last_match[1], Regexp.last_match[2], Regexp.last_match[3] ]
        end

        def initialize require_prefix: nil
          @require_prefix = require_prefix
        end
        
	    	def call
	    	  prev_indents = [ 0 ]
          lines = text.lines.each_with_index.map do |line, index|
            [ index, line, *split(line) ]
          end

          half_lines = []
          
	    	  lines.each do |index, entire, indent, is_block_open, rest|            
	    	    log "#{pad_number index} #{pad_number prev_indents.last, 2}->#{pad_number indent.length, 2} #{entire.chomp}"
	    	    if prev_indents.last < indent.length
	    	      prior = lines[index-1]
              raise BadBlockError, "Bad block open on line ##{index}" if @require_prefix && (prior[3].nil? || prior[3].empty?)
              
	    	      log "#{pad_number index}        Blockify prior line `#{prior[1].chomp}'."

              half_lines.push [ index - 1.5, "#{prior[2]}bubble do \n" ]
	    	      lines[index-1][1] = "#{indent}#{prior[4]}\n"

	    	      prev_indents.push indent.length
	    	    elsif prev_indents.last > indent.length
	    	      log "#{pad_number index}        Leave block"

	    	      while prev_indents.last != indent.length
	    	        begin                  
                  raise IndentationError, "Bad outdent on line ##{index}" if prev_indents[-2].nil?
	    	          lines[index-1][1] << "#{" " * prev_indents[-2]}end\n"
	    	        rescue ArgumentError
	    	          raise RuntimeError, "Bad unindent."
	    	        end
	    	        prev_indents.pop
	    	      end
	    	    end
	    	  end

	    	  while prev_indents.last  != 0
            s = "#{" " * prev_indents[-2]}end\n"
	    	    lines << [lines.length+1, s]
	    	    prev_indents.pop
	    	  end
					(lines + half_lines).sort_by(&:first).map do |l|
            l[1]
          end.join
	    	end
			end
		end
	end
end
