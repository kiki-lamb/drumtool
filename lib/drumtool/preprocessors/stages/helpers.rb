module DrumTool
	module Preprocessors
	  class Base
	  	class << self			  
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

	    	def partially_disassemble_line line
	    	  line << "\n" unless line[-1] == "\n"
	    	  /(\s*)((?:.(?!#{PatBlockArgs}))*)\s*(#{PatBlockArgs})?/.match line

	    	  [ Regexp.last_match[1], Regexp.last_match[2].strip, (Regexp.last_match[3] || "").strip ]
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
      end
		end
	end
end
