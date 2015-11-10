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
          rubify_pythonesque_blocks

          @text
        ensure
          clear_text
        end
        
        private 

				PatName = /[a-z][a-z0-9_]*/

        def rubify_pythonesque_blocks
				  log ""

          lines = @text.lines
					prev_indents = [ 0 ]

					lines.each_with_index do |line, index|
					  /^(\s*)/.match line
						indent = Regexp.last_match[0].length

						log "#{prev_indents.last}->#{indent} #{line}"

						if prev_indents.last < indent
						  prior = lines[index-1]

						  log "Enter"
							/((?:.(?!\|.+\|\s*\n$))*)(.*)/.match prior
							head, args = Regexp.last_match[1], Regexp.last_match[2]

							log "PRIOR: `#{prior}'"
							log "HEAD:  `#{head}'"
							log "ARGS:  `#{args}'"

						  lines[index-1] = "#{head} do #{args.strip}\n" 

#						  lines[index-1] = "#{prior.chomp} do \n" 

							prev_indents.push indent
						elsif prev_indents.last > indent
						  log "Leave"

							while prev_indents.last != indent
    						lines[index-1] << "#{" " * (prev_indents.last-2)}end\n"
								prev_indents.pop
              end
					  end
					end

					@text = lines.join
        end

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

            log "#{is_comment}: `#{indent}' #{"awaiting `#{waiting_for_indent}'" if waiting_for_indent}: `#{rest.chomp}'" if @logger

            if waiting_for_indent && indent.length <= waiting_for_indent.length
              log "Leaving comment."
              waiting_for_indent = nil 
            end

            if is_comment && ! waiting_for_indent             
              log "Enter comment."
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