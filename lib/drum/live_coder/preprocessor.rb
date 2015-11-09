class Drum
  class LiveCoder
    class Preprocessor
      class << self
        def call text
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
          
          out << "end\n\n" if last_indent.length > 0
          out.string
        end
      end 
    end
  end
end