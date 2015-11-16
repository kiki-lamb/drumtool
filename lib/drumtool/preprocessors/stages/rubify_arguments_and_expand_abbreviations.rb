module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
	    	def rubify_arguments_and_expand_abbreviations text
	    	  lines = text.lines

	    	  lines.each_with_index do |line, index|
	    	    log "#{pad_number index} #{line.chomp}"

	    	    indent, name, args, block_args = *disassemble_line(line)
	    	    lines[index] = reassemble_line indent, name, args, block_args
	    	  end

					lines.join
	    	end
			end
		end
	end
end