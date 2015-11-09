require "digest"
require "stringio"

class Drum
  class LiveCoder
    def initialize filename, refresh_interval = 16
      @__filename__ = filename
      @__refresh_interval__ = refresh_interval
      @__hash__, @__engine__ = nil, nil
      @exception = false
    end

    attr_reader :exception

    def self.preprocess text
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
)}\n" 
      
      end
      
      out << "end\n\n" if last_indent.length > 0
      out.string
    end

    def refresh
      text = File.open(@__filename__).read
      hash = Digest::MD5.new.tap do |d|
        d << text
      end.hexdigest

      if hash != @__hash__
        @__hash__ = hash

        begin
          proc = eval "\nProc.new do\n#{self.class.preprocess File.open("#{@__filename__}").read}\nend"
          @exception = nil
          @__engine__ = Drum.build &proc
#        rescue Exception => e
#          @exception = e
#          nil
        end
      end
    end

    def run
        tick = 0

        while true do 
          begin
#           puts "\n\n#{@__engine__.to_s(0..63)}" if (tick%@__refresh_interval__) == 0 && refresh

            refresh if tick%@__refresh_interval__ == 0

            io = StringIO.new
            @__engine__.play tick, log: io
            io << "WARNING: #{@exception.to_s}" if @exception
            $stdout << io.string
          ensure
            tick += 1
          end
        end
      end
  end 
end