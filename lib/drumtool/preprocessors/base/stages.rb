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
	      
	      def rubify_arg arg      
	        if PatRangeExact.match arg
	          tmp = "(#{arg.gsub /(?<!0)[xX]/, "0x"})"
	          log "  Arg `#{arg}' is a Range: `#{tmp}'"
	        elsif PatIntOrHexExact.match arg
	          tmp = arg.sub /^[xX]/, "0x"
	          log "  Arg `#{arg}' is a IntOrHex: `#{tmp}'"
	        elsif PatModuloExact.match arg
	          arg.sub! /%[xX]/, "%0x"
	          tmp = "(Proc.new { |t| t#{arg} })"
	          log "  Arg `#{arg}' is a Modulo: `#{tmp}'"      
	        elsif PatNameExact.match arg
	          tmp = ":#{arg}"
	          log "  Arg `#{arg}' is a Name: `#{tmp}'"
	        else
	          raise ArgumentError, "Unrecognized argument"
	        end
	        
	        tmp
	      end

	      def rubify_arguments_and_expand_abbreviations
	        lines = text.lines

	        lines.each_with_index do |line, index|
	          log "#{pad_number index} #{line.chomp}"

	          indent, name, args, block_args = *disassemble_line(line)
	          lines[index] = reassemble_line indent, name, args, block_args
	        end

	        self.text =  lines.join
	      end

	      def partially_disassemble_line line
	        line << "\n" unless line[-1] == "\n"
	        /(\s*)((?:.(?!#{PatBlockArgs}))*)\s*(#{PatBlockArgs})?/.match line

	        [ Regexp.last_match[1], Regexp.last_match[2].strip, (Regexp.last_match[3] || "").strip ]
	      end 

	      def expand name 
	        self.class.expand(name) || name
	      end

	      def disassemble_line line
	        indent, body, block_args = *partially_disassemble_line(line)

	        if PatSimpleExpr.match body
	          log "  Parsed simple expr: #{Regexp.last_match.inspect[12..-2]}"

	          name, args = expand(Regexp.last_match[1]), (Regexp.last_match[2] || "").split(/\s+/).map do |arg|
	            rubify_arg arg
	          end
	        else
	          log "  Parse complex expr: `#{body}'"         
	          body = "#{Regexp.last_match[1]}#{expand Regexp.last_match[2]}#{Regexp.last_match[3]}" if /^(\s*)(#{PatName})(.*)$/.match body             
						body.sub! /trigger\s+{(?!\s*\|t\|)/,  "trigger Proc.new { |t| "
	          name, args = body, []
	        end  
	        
	        toks = [ indent, name, args, block_args ]
	        log "  Tokens: #{toks.inspect}"
	        toks
	      end

	      def reassemble_line indent, name, args, block_args
	        tmp = "#{indent}#{name}#{args.empty?? "" : "(#{args.join ', '})"}#{" #{block_args.strip}" unless block_args.empty?}\n"
	        log "  Reassembled: `#{tmp.chomp}'"
	        tmp
	      end

	      def rubify_pythonesque_blocks
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

	        self.text =  lines.join
	      end

	      def strip_blank_lines_and_trailing_whitespace
	        text.gsub! /(?:\s*\n)+/m, "\n"
	      end

	      def strip_blank_lines_and_trailing_whitespace_and_comments
	        text.gsub! /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
	      end

	      def extend_block_comments
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

	        self.text =  o.string
	    end 
		end
	end
end