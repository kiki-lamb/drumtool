module DrumTool
  module Preprocessors
    class Thesaurus
      include Logging

      class Ambiguous < Exception; end

      attr_accessor :min_length, :strict, :lenient_vowels

      def initialize *abbreviables, min_length: 1, strict: false, lenient_vowels: true, **synonyms
        self.min_length = min_length
        self.strict = strict
        self.lenient_vowels = lenient_vowels

        @table = Hash.new

        abbreviate *abbreviables, **synonyms
      end 

      def synonym **opts
        abbreviate **opts
      end

      def abbreviate *args, **opts
        safe_merge! ary_to_h args
        safe_merge! Hash[opts.map do |k,v| 
          [*v].map do |v|
            [ v, k ]
          end
        end.flatten(1)]
      end

      def [] abr
        abr = abr.to_s

        exclaim = if abr.end_with? "!"
                    puts "CAPTURE '!'"
                    abr = abr[0..abr.length-2] 
                    true
                  end
        
        if abr.length >= min_length
          candidates = @table.select do |key|           
            key.start_with?(abr) || (lenient_vowels && mumble(key).start_with?(abr))
          end.tap { |cs| puts "CS: #{cs.inspect}" }
        
          unless candidates.none?
            if candidates.one?
              word, synonym = *candidates.first
              
              tmp = synonym || word
              puts "TMP: #{tmp}"
              tmp << "!" if exclaim
              tmp
            else
              raise AmbiguousLookup, "`#{abr}' is ambiguous" if strict
            end
          end
        end
      end

      private
      def mumble s
        s.gsub /(?<!^)[aeiou]/, ""
      end

      def ary_to_h ary
        Hash[ary.map { |w| [w, nil ] }]
      end

      def stringify_h h
        Hash[h.map do |k,v|
          [ k.to_s, v ? v.to_s : v ]
        end]
      end

      def safe_merge! hash
        @table.merge! stringify_h(hash) do |k, o, v|
          raise ArgumentError, "`#{k}' already defined." unless o.nil? || o == v
        end
      end
    end
  end
end
