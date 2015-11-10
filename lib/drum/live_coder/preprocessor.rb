require "stringio"

class Drum
  class LiveCoder
    class Preprocessor
      class << self
        Abbreviations = {
          "refr" => "refresh_interval",
          "ref" => "refresh_interval",

          "on" => "trigger",
          "when" => "trigger",
          "tr" => "trigger",
          "trig" => "trigger",

          "inst" => "instrument",
          "ins" => "instrument",
          "i" => "instrument",

          "rot" => "rotate",

          "sh" => "shift",

          "lp" => "loop",
					"sc" => "loop",
					"scp" => "loop",
					"scope" => "loop",

          "mu" => "mute",

          "fl" => "flip",
          "f" => "flip"
        }

        def call text, logger: nil
          @@text = text 
					@@text << "\n"

          @@logger = logger
          
          untabify
          strip_blank_lines_and_trailing_whitespace 
          extend_block_comments
          strip_blank_lines_and_trailing_whitespace_and_comments
          rubify_arguments_and_expand_abbreviations
          rubify_pythonesque_blocks

          @@text
        ensure
          log "\nPREPROCESSED:"
          log "=" * 80
          log @@text
          log "=" * 80
					log "\n"
          clear_text
        end
        
        private 
        PatBlockArgs = /(?:\|.+\|\s*\n$)/
        PatName = /(?:[a-z][a-z0-9_]*)/
        PatNameExact = /^#{PatName}$/
        PatNumber = /(?:\d+(?:[\.]\d+)?)/
        PatNumberExact = /^#{PatNumber}$/
        PatInt = /(?:\d+)/
        PatRange = /#{PatInt}\.\.#{PatInt}/
        PatRangeExact = /^#{PatRange}$/
        PatModProc = /(?:%#{PatNumber})/
        PatModProcExact = /^#{PatModProc}$/
        PatArg = /#{PatName}|#{PatRange}||#{PatNumber}|#{PatModProc}/
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
            "(Proc.new { |t| t#{arg} })"
          elsif PatRangeExact.match arg
            log "ARG `#{arg}' is a Range"
            "(#{arg})"
          else
            raise ArgumentError, "Unrecognized argument"
          end
        end

        def rubify_arguments_and_expand_abbreviations
          log ""

          lines = @@text.lines

          lines.each_with_index do |line, index|
            log "\nTOKENIZE `#{line.chomp}'"

            indent, name, args, block_args = *disassemble_line(line)
            lines[index] = reassemble_line indent, name, args, block_args
          end

          @@text = lines.join
        end

        def partially_disassemble_line line
          line << "\n" unless line[-1] == "\n"
          /(\s*)((?:.(?!#{PatBlockArgs}))*)\s*(#{PatBlockArgs})?/.match line

          [ Regexp.last_match[1], Regexp.last_match[2].strip, (Regexp.last_match[3] || "").strip ]
        end 

        def expand name 
          Abbreviations.include?(name) ? Abbreviations[name] : name
        end

        def disassemble_line line
          indent, body, block_args = *partially_disassemble_line(line)

          if PatSimpleExpr.match body
            log "PARSE SIMPLE EXPR: #{Regexp.last_match.inspect}"

            name, args = expand(Regexp.last_match[1]), (Regexp.last_match[2] || "").split(/\s+/).map do |arg|
              rubify_arg arg
            end
          else
            log "PARSE COMPLEX EXPR: `#{body}'"         
            body = "#{Regexp.last_match[1]}#{expand Regexp.last_match[2]}#{Regexp.last_match[3]}" if /^(\s*)(#{PatName})(.*)$/.match body             
            name, args = body, []
          end  
          
          toks = [ indent, name, args, block_args ]
          log "TOKS: #{toks.inspect}"
          toks
        end

        def reassemble_line indent, name, args, block_args
          "#{indent}#{name}#{args.empty?? "" : "(#{args.join ', '})"}#{" #{block_args.strip}" unless block_args.empty?}\n"
        end

        def rubify_pythonesque_blocks
          log "\n\n DOING BLOCKS!"

          lines = @@text.lines
          prev_indents = [ 0 ]

          lines.each_with_index do |line, index|
            log "\nTOKENIZE `#{line.chomp}'"
            indent = partially_disassemble_line(line).first
            log "#{prev_indents.last}->#{indent.length} `#{line}'"

            if prev_indents.last < indent.length
              prior = lines[index-1]

              log "Enter on `#{prior.chomp}'."
              pindent, pbody, pblock_args = *partially_disassemble_line(prior)

              log "pindent = `#{pindent}'"
              log "pbody = `#{pbody}'"
              log "pblock_args = `#{pblock_args}'"

              lines[index-1] = "#{pindent}#{pbody} do #{pblock_args}\n"

              prev_indents.push indent.length
            elsif prev_indents.last > indent.length
              log "Leave"

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
            lines << "#{" " * (prev_indents.last-2)}end\n"
            prev_indents.pop
          end

          @@text = lines.join
        end

        def log s
          @@logger << s.chomp << "\n" if @@logger
        end

        def clear_text
          @@text = nil
        end

        def untabify 
          @@text.gsub! /\t/m, '  '       
        end

        def strip_blank_lines_and_trailing_whitespace
          @@text.gsub! /(?:\s*\n)+/m, "\n"
        end

        def strip_blank_lines_and_trailing_whitespace_and_comments
          @@text.gsub! /(?:\s*(?:#[^\n]*)?\n)+/m, "\n"
        end

        def extend_block_comments
          o = StringIO.new
          waiting_for_indent = nil
          
          @@text.lines.each do |line|
            /(\s*)(#?)(\s*)(.*\n)/.match line
            indent     = "#{Regexp.last_match[1]}#{Regexp.last_match[3]}"
            is_comment = ! Regexp.last_match[2].empty?
            rest       = Regexp.last_match[4]

            log "#{is_comment}: `#{indent}' #{"awaiting `#{waiting_for_indent}'" if waiting_for_indent}: `#{rest.chomp}'" if @@logger

            if waiting_for_indent && indent.length <= waiting_for_indent.length
              log "Leaving comment."
              waiting_for_indent = nil 
            end

            if is_comment && ! waiting_for_indent             
              log "Enter comment."
              waiting_for_indent = "#{indent} "
            end
            
            is_comment = "# " if waiting_for_indent
            o << "#{is_comment if is_comment}#{indent}#{rest}"
          end

          @@text = o.string
        end
      end 
    end
  end
end