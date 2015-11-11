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
          "n" => "instrument",

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

          %i{ untabify
              strip_blank_lines_and_trailing_whitespace 
              extend_block_comments
              strip_blank_lines_and_trailing_whitespace_and_comments
              rubify_arguments_and_expand_abbreviations
              rubify_pythonesque_blocks 
          }.each do |sym|

              log_separator
              log "#{name} performing step: #{sym}"
              log_separator
              send sym
              log_separator
              log "#{name}'s text after performing step: #{sym}"
              log_separator
              log_text
          end           

          @@text
        ensure
          log_separator
          clear_text
        end
        
        private 
				def pad_number num, siz = 4
				  num.to_s.rjust(siz, "0")
				end

				def log_separator
				  log "=" * 80
				end

        def log_text
          @@text.lines.each_with_index do |line, index|
            log "#{pad_number index} #{line}"
          end
        end

        PatBlockArgs = /(?:\|.+\|\s*\n$)/
        PatName = /(?:[a-z][a-z0-9_]*)/
        PatNameExact = /^#{PatName}$/
        PatNumber = /(?:\d+(?:[\.]\d+)?)/
        PatNumberExact = /^#{PatNumber}$/
        PatInt = /(?:\d+)/
        PatRange = /#{PatInt}\.\.#{PatInt}/
        PatRangeExact = /^#{PatRange}$/
        PatModulo = /(?:%#{PatNumber})/
        PatModuloExact = /^#{PatModulo}$/
        PatArg = /#{PatName}|#{PatRange}||#{PatNumber}|#{PatModulo}/
        PatSimpleExpr = /^\s*(#{PatName})\s*(#{PatArg}(?:\s+#{PatArg})*)?\s*$/
      
        def rubify_arg arg      
          if PatNumberExact.match arg
            tmp = arg.to_s
            log "Arg `#{arg}' is a Number: `#{tmp}"
          elsif PatNameExact.match arg
            tmp = ":#{arg}"
            log "Arg `#{arg}' is a Name: `#{tmp}"           
          elsif PatModuloExact.match arg
            tmp = "(Proc.new { |t| t#{arg} })"
            log "Arg `#{arg}' is a Modulo: `#{tmp}"      
          elsif PatRangeExact.match arg
            tmp = "(#{arg})"
            log "Arg `#{arg}' is a Range: `#{tmp}"
          else
            raise ArgumentError, "Unrecognized argument"
          end
          
          tmp
        end

        def rubify_arguments_and_expand_abbreviations
          lines = @@text.lines

          lines.each_with_index do |line, index|
            log "#{pad_number index} #{line.chomp}"

            indent, name, args, block_args = *disassemble_line(line)
            lines[index] = reassemble_line indent, name, args, block_args

            log "\n"
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
            log "Parsed simple expr: #{Regexp.last_match.inspect}"

            name, args = expand(Regexp.last_match[1]), (Regexp.last_match[2] || "").split(/\s+/).map do |arg|
              rubify_arg arg
            end
          else
            log "Parse complex expr: `#{body}'"         
            body = "#{Regexp.last_match[1]}#{expand Regexp.last_match[2]}#{Regexp.last_match[3]}" if /^(\s*)(#{PatName})(.*)$/.match body             
            name, args = body, []
          end  
          
          toks = [ indent, name, args, block_args ]
          log "Tokens: #{toks.inspect}"
          toks
        end

        def reassemble_line indent, name, args, block_args
          tmp = "#{indent}#{name}#{args.empty?? "" : "(#{args.join ', '})"}#{" #{block_args.strip}" unless block_args.empty?}\n"
          puts "Reassembled: `#{tmp.chomp}'"
          tmp
        end

        def rubify_pythonesque_blocks
          lines = @@text.lines
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
          
          @@text.lines.each_with_index do |line, index|
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

          @@text = o.string
        end
      end 
    end
  end
end