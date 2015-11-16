module DrumTool
	module Preprocessors
	  module Stages
		  module RubifyArgumentsAndExpandAbbreviations
			  extend Helpers
				extend StageHelpers

	    	def self.call pp
	    	  lines = pp.text.lines

	    	  lines.each_with_index do |line, index|
	    	    pp.log "#{pad_number index} #{line.chomp}"

	    	    indent, name, args, block_args = *disassemble_line(line)
	    	    lines[index] = reassemble_line indent, name, args, block_args
	    	  end

					lines.join
	    	end
			end
		end
	end
end