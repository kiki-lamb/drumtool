require "stringio"

module DrumTool
  module Preprocessors
    module Stages
      class ExtendBlockComments < Base
        def call
          text << "\n"
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
    end
  end
end
