require "stringio"

module DrumTool
	module Preprocessors
	  class Base
		  class << self			  
	      def untabify text
	        text.gsub /\t/m, '  '       
	      end

			  def procify text
			    "Proc.new {\n#{text}\n}"
			  end

	    	def strip_blank_lines_and_trailing_whitespace text
	    	  text.gsub /(?:\s*\n)+/m, "\n"
	    	end

	    	def strip_blank_lines_and_trailing_whitespace_and_comments text
	    	  text.gsub /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
	    	end

	    	def extend_block_comments text
	    	  o = StringIO.new
	    	  waiting_for_indent = nil
	    	  
	    	  text.lines.each_with_index do |line, index|
	    	    /(\s*)(#?)(\s*)(.*\n)/.match line
	    	    indent     = "#{Regexp.last_match[1]}#{Regexp.last_match[3]}"
	    	    is_comment = ! Regexp.last_match[2].empty?
	    	    rest       = Regexp.last_match[4]

	    	    if waiting_for_indent && indent.length <= waiting_for_indent.length
	    	      log "#{pad_number index} Leaving comment."
	    	      waiting_for_indent = nil 
	    	    end

	    	    if is_comment && ! waiting_for_indent             
	    	      log "#{pad_number index} Enter comment."
	    	      waiting_for_indent = "#{indent} "
	    	    end
	    	    
	    	    is_comment = "# " if waiting_for_indent

	    	    tmp = "#{is_comment if is_comment}#{indent}#{rest}"

	    	    log "#{pad_number index} #{tmp.chomp} #{"# (awaiting `#{waiting_for_indent.length}')" if waiting_for_indent}"

	    	    o << tmp
	    	  end

					o.string
	    	end 

			end

	    PatBlockArgs = /(?:\|.+\|\s*\n$)/
	    PatName = /(?:[a-z][a-z0-9_]*)/
	    PatNameExact = /^#{PatName}$/
	    PatHex = /(?:0?[xX][\da-fA_F]+)/
	    PatHexExact = /^#{PatHex}$/
	    PatFloat = /(?:\d+(?:[\.]\d+)?)/
	    PatFloatExact = /^#{PatFloat}$/
	    PatInt = /(?:\d+)/
	    PatIntExact = /^#{PatInt}$/
	    PatIntOrHex = /#{PatHex}|#{PatInt}/
	    PatIntOrHexExact = /^#{PatIntOrHex}$/
	    PatRange = /#{PatIntOrHex}\.\.#{PatIntOrHex}/
	    PatRangeExact = /^#{PatRange}$/
	    PatModulo = /(?:%#{PatIntOrHex})/
	    PatModuloExact = /^#{PatModulo}$/
	    PatArg = /#{PatRange}|#{PatIntOrHex}|#{PatModulo}|#{PatName}/
	    PatSimpleExpr = /^\s*(#{PatName})\s*(#{PatArg}(?:\s+#{PatArg})*)?\s*$/	    

	    def rubify_arguments_and_expand_abbreviations
	      lines = text.lines

	      lines.each_with_index do |line, index|
	        log "#{self.class.pad_number index} #{line.chomp}"

	        indent, name, args, block_args = *disassemble_line(line)
	        lines[index] = reassemble_line indent, name, args, block_args
	      end

	      self.text =  lines.join
	    end

	    def rubify_pythonesque_blocks
	      lines = text.lines
	      prev_indents = [ 0 ]

	      lines.each_with_index do |line, index|
	        indent = partially_disassemble_line(line).first
	        log "#{self.class.pad_number index} #{self.class.pad_number prev_indents.last, 2}->#{self.class.pad_number indent.length, 2} #{line.chomp}"

	        if prev_indents.last < indent.length
	          prior = lines[index-1]

	          log "#{self.class.pad_number index}        Blockify prior line `#{prior.chomp}'."
	          pindent, pbody, pblock_args = *partially_disassemble_line(prior)

	          lines[index-1] = "#{pindent}#{pbody} do #{pblock_args}\n"

	          prev_indents.push indent.length
	        elsif prev_indents.last > indent.length
	          log "#{self.class.pad_number index}        Leave block"

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

	      self.text =  lines.join
	    end
		end
	end
end