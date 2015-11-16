module DrumTool
	module Preprocessors
	  module Stages
		  class RubifyArgumentsAndExpandAbbreviations < Base
			  include StageHelpers

	    	def call
	    	  lines = text.lines

	    	  lines.each_with_index do |line, index|
	    	    log "#{pp.class.pad_number index} #{line.chomp}"

	    	    indent, name, args, block_args = *disassemble_line(line)
	    	    lines[index] = reassemble_line indent, name, args, block_args
	    	  end

					lines.join
	    	end
			end
		end
	end
end