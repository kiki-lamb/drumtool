require "stringio"

class Drum
  class LiveCoder
    class ImprovedPreprocessor
      class << self
        def call text, logger: nil
          set_text text
          @logger = logger
          
          untabify
          strip_blank_lines_and_trailing_whitespace 
          extend_block_comments
          strip_blank_lines_and_trailing_whitespace_and_comments
					rubify_arguments
          # rubify_pythonesque_blocks

          @text
        ensure
          clear_text
        end
        
        private 

				PatBlockArgs = /(?:\|.+\|\s*\n$)/
				PatName = /(?:[a-z][a-z0-9_]*)/
				PatNameExact = /^#{PatName}$/
				PatNumber = /(?:\d+(?:[\.]\d+)?)/
				PatNumberExact = /^#{PatNumber}$/
				PatModProc = /(?:%#{PatNumber})/
				PatModProcExact = /^#{PatModProc}$/
				PatArg = /#{PatName}|#{PatNumber}|#{PatModProc}/
				PatSimpleExpr = /^\s*(#{PatName})\s*(#{PatArg}(?:\s+#{PatArg})*)?\s*$/
			
			  def rubify_arg arg			
				  if PatNumberExact.match arg
					  log "ARG `#{arg}' is a Number"
					  arg.to_s
					elsif PatNameExact.match arg
					  log "ARG `#{arg}' is a Name"
					  ":#{arg}"
					elsif PatModProcExact.match arg
					  log "ARG `#{arg}' is a ModProc"
					  "{ |t| t#{arg} }"
					else
					  raise ArgumentError, "Unrecognized argument"
					end
				end

        def rubify_arguments
				  log ""

          lines = @text.lines

					lines.each_with_index do |line, index|
					  log "\nTOKENIZE `#{line.chomp}'"

						indent, name, args, block_args = *tokenize(line)
						lines[index] = reassemble_line indent, name, args, block_args
					end

					@text = lines.join
        end

				def disassemble_line line 
				  line << "\n" unless line[-1] == "\n"
					/(\s*)((?:.(?!#{PatBlockArgs}))*)\s*(#{PatBlockArgs})?/.match line

					indent, body, block_args = Regexp.last_match[1], Regexp.last_match[2].strip, (Regexp.last_match[3] || "").strip

					if PatSimpleExpr.match body
			     log "PARSE SIMPLE EXPR: #{Regexp.last_match.inspect}"

					  name, args = Regexp.last_match[1], (Regexp.last_match[2] || "").split(/\s+/).map do |arg|
						  rubify_arg arg
						end
					else
			      log "PARSE COMPLEX EXPR: `#{body}'"

					  name, args = body, []
					end	 
					
					toks = [ indent, name, args, block_args ]
					log "TOKS: #{toks.inspect}"
					toks
				end

				def reassemble_line indent, name, args, block_args
#				  log "reassemble indent = `#{indent}'"
#				  log "reassemble name = `#{name}'"
#				  log "reassemble args = #{args.inspect}"
#				  log "reassemble block_args = `#{block_args}'"

				  tmp = "#{indent}#{name}#{args.empty?? "" : "(#{args.join ', '})"}#{" #{block_args.strip}" unless block_args.empty?}\n"
					log "Reasssembled: `#{tmp}'"
					tmp
				end


        def rubify_arguments
				  log ""

          lines = @text.lines

					lines.each_with_index do |line, index|
					  log "\nTOKENIZE `#{line.chomp}'"

						indent, name, args, block_args = *disassemble_line(line)
						lines[index] = reassemble_line indent, name, args, block_args
					end

					@text = lines.join
        end

#        def rubify_pythonesque_blocks
#				  log ""
#
#          lines = @text.lines
#					prev_indents = [ 0 ]
#
#					lines.each_with_index do |line, index|
#					  log "\nTOKENIZE `#{line.chomp}'"
#						indent, name, args, block_args = *disassemble_line(line)
##						log "#{prev_indents.last}->#{indent.length} `#{indent}' `#{name}' `#{args.inspect}' `#{block_args}'"
#
#						lines[index] = reassemble_line indent, name, args, block_args
#
#						if prev_indents.last < indent.length
#						  prior = lines[index-1]
#
#						  log "Enter on `#{prior.chomp}'."
#							pindent, pname, pargs, pblock_args = *disassemble_line(prior)
#							pname << " do"
#						  lines[index-1] = reassemble_line pindent, pname, pargs, pblock_args
#
#							prev_indents.push indent.length
#						elsif prev_indents.last > indent.length
#						  log "Leave"
#
#							while prev_indents.last != indent.length
#    						lines[index-1] << "#{" " * (prev_indents.last-2)}end\n"
#								prev_indents.pop
#              end
#					  end
#					end
#
#					while prev_indents.last != 0
#    				lines << "#{" " * (prev_indents.last-2)}end\n"
#						prev_indents.pop
#          end
#
#					@text = lines.join
#        end

        def log s
          @logger << s.chomp << "\n" if @logger
        end

        def set_text text
          @text = text
        end

        def clear_text
          @text = nil
        end

        def untabify 
          @text.gsub! /\t/m, '  '       
        end

        def strip_blank_lines_and_trailing_whitespace
          @text.gsub! /(?:\s*\n)+/m, "\n"
        end

        def strip_blank_lines_and_trailing_whitespace_and_comments
          @text.gsub! /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
        end

        def extend_block_comments
          o = StringIO.new
          waiting_for_indent = nil
          
          @text.lines.each do |line|
            /(\s*)(#?)(\s*)(.*\n)/.match line
            indent     = "#{Regexp.last_match[1]}#{Regexp.last_match[3]}"
            is_comment = ! Regexp.last_match[2].empty?
            rest       = Regexp.last_match[4]

#            log "#{is_comment}: `#{indent}' #{"awaiting `#{waiting_for_indent}'" if waiting_for_indent}: `#{rest.chomp}'" if @logger

            if waiting_for_indent && indent.length <= waiting_for_indent.length
#              log "Leaving comment."
              waiting_for_indent = nil 
            end

            if is_comment && ! waiting_for_indent             
 #             log "Enter comment."
              waiting_for_indent = indent 
            end
            
            is_comment = "# " if waiting_for_indent
            o << "#{is_comment if is_comment}#{indent}#{rest}"
          end

          @text = o.string
        end

        def old_call text
          last_indent = ""
          out = StringIO.new

          text.lines.map(&:chomp).each do |line|
            this_indent = /\s*/.match(line)[0]        
            out << "end\n" if this_indent.length < last_indent.length           
            last_indent = this_indent
            out << "#{(line  
                .gsub /(\s*on\s+)((?:(?:%?\d+)+)(?:\s+(?:%?\d+)+)*)/ do
                r1, r2 = Regexp.last_match[1], Regexp.last_match[2]  
                Regexp.last_match[2].split(/\s+/).map do |n|
                  if n[0] == "%"
                    "#{r1}{ |t| t#{n} }"
                  else
                    "#{r1}{ |t| t == #{n} }"
                  end
                end.join "\n"
              end
              .gsub /(\s*on\s*$)/ do 
                ""
              end
              .gsub /(\s*on\s+)(?!do)(?!{)(.*)/ do 
                "#{Regexp.last_match[1]}{ |t| #{Regexp.last_match[2]} }"
              end
              .gsub /(\s*instrument\s+)(?!\:)([\w_]*)(?:\s+(\d+))?/ do
                "#{Regexp.last_match[1]}:#{Regexp.last_match[2]} do#{"\n#{last_indent}  note #{Regexp.last_match[3]}" if "" != Regexp.last_match[3].to_s}"  
              end
              .gsub /(\s*muted_by\s+)(?![\:])(.*)/ do
                "#{Regexp.last_match[1]}:#{Regexp.last_match[2]}"
              end
              .gsub /(\s*mutes\s+)(?![\:])(.*)/ do
                "#{Regexp.last_match[1]}:#{Regexp.last_match[2]}"
              end
)}\n    " 
          
          end
          
          out << "end\n\n" if last_indentooo.length > 0
          out.string
        end
      end 
    end
  end
end