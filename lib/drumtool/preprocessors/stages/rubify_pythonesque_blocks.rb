module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
	    	def rubify_pythonesque_blocks text
	    	  lines = text.lines
	    	  prev_indents = [ 0 ]

	    	  lines.each_with_index do |line, index|
	    	    indent = partially_disassemble_line(line).first
	    	    log "#{pad_number index} #{pad_number prev_indents.last, 2}->#{pad_number indent.length, 2} #{line.chomp}"

	    	    if prev_indents.last < indent.length
	    	      prior = lines[index-1]

	    	      log "#{pad_number index}        Blockify prior line `#{prior.chomp}'."
	    	      pindent, pbody, pblock_args = *partially_disassemble_line(prior)

	    	      lines[index-1] = "#{pindent}#{pbody} do #{pblock_args}\n"

	    	      prev_indents.push indent.length
	    	    elsif prev_indents.last > indent.length
	    	      log "#{pad_number index}        Leave block"

	    	      while prev_indents.last != indent.length
	    	        begin 
	    	          lines[index-1] << "#{" " * prev_indents[-2]}end\n"
	    	        rescue ArgumentError
	    	          raise RuntimeError, "Bad unindent."
	    	        end
	    	        prev_indents.pop
	    	      end
	    	    end
	    	  end

	    	  while prev_indents.last != 0
	    	    lines << "#{" " * (prev_indents[-2])}end\n"
	    	    prev_indents.pop
	    	  end

					lines.join
	    	end
			end
		end
	end
end