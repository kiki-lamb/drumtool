module DrumTool
  module Preprocessors
    class Base
      include Logging
      include Stages

      class << self
        def pad_number num, siz = 4
          num.to_s.rjust siz, "0" 
        end

        def call text
          new(text).result
        end
        
        def pad_number num, siz = 4
          num.to_s.rjust siz, "0" 
        end

        def stages *stages_
          stages_ = Array [*stages_].flatten 1 if stages_

          (@stages ||= []).tap do |s|
            s.push *stages_
          end           
        end

        def abbreviate *a, **o
          raise ArgumentError, "Use 'synonymize' to add synonyms." unless o.empty?
          a = Array [*a].flatten 1 if a.any?
          thesaurus.abbreviate *a
        end

        def synonymize *a, **o
          raise ArgumentError, "Use 'abbreviate' to add abbreviations." unless a.empty?
          thesaurus.abbreviate **o
        end

        def expand name
          thesaurus[name] || name
        end

        private
        def thesaurus
          @thesaurus ||= Thesaurus.new
        end
      end
                      
      attr_reader :text

      def text= v
        @result = nil
        @text = v
      end

      def initialize text = ""
        self.text = if File === text
          text.read
        else
          text
        end
      end

      def log_separator
        log "=" * 80
      end

      def log_text
        text.lines.each_with_index do |line, index|
          log "#{self.class.pad_number index} #{line}"
        end
      end

      def call(text)
        self.text = text
        result
      end

      def result
        @result ||= begin
          text << "\n"

          self.class.stages.each do |obj|
              log_separator
              log "#{self.class.name} performing step: #{obj}"
              log_separator
              
              self.text = if Class === obj
                obj.new(self).call
              elsif obj.respond_to? :call
                case obj.method(:call_on).arity
                when 1
                  obj.call_on self
                else
                  raise ArgumentError, "A callable stage should have 1 arguments."
                end
              elsif respond_to? obj
                send obj
              else
                self.class.send obj, text
              end

              log_separator
              log "#{self.class.name}'s text after performing step: #{obj}"
              log_separator
              log_text
          end
          text
        end
      end                
    end
  end
end
