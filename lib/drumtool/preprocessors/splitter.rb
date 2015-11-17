module DrumTool
  module Preprocessors
    class Splitter
      attr_reader *%i{ text source head body tail ruby }
      
      def initialize text
        @text = text

        @res = {}

        @head, @body    = *@text.split(re :HEAD)
        @body, @head    = @head, "" unless @body

        discard, @body  = *@body.split(re :BOF)
        @body         ||= discard
        
        @body, discard  = *@body.split(re :EOF)
        @body         ||= discard

        @body, @tail    = *@body.split(re :TAIL)
        @body, @tail    = @tail, "" unless @body
        
        @body, @ruby    = *@body.split(re :RUBY)
        @body, @ruby    = @ruby, "" unless @body
        
        @source = "#{"#{@head}#{@body}#{@tail}".gsub(/\n\s*\n+/, "\n").strip}\n"
        @ruby ||= ""
        @ruby = "#{ruby.gsub(/\n\n+/, "\n").strip}\n"
      end

      private
      def re tag
        @res[tag] ||= /^##{tag.to_s}\s*$/
      end
    end
  end
end
