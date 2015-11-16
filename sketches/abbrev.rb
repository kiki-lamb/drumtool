require './lib/drumtool'

class Thesaurus
	include Logging

	class Ambiguous < Exception; end

	attr_accessor :min_length, :strict

	def initialize *abbreviables, min_length: 2, strict: false, **synonyms
		self.min_length = min_length
		self.strict = strict

		@table = Hash.new

	  abbreviate *abbreviables, **synonyms
	end	

	def synonym **opts
	  abbreviate **opts
	end

	def abbreviate *args, **opts
		safe_merge! ary_to_h args
		safe_merge! opts
	end

	def [] abr
	  abr = abr.to_s

		if abr.length >= min_length
		  candidates = @table.select do |key|
		    key.start_with? abr
		  end
		
		  unless candidates.none?
				if candidates.one?
				  word, synonym = *candidates.first
					synonym || word
				else
					raise AmbiguousLookup, "`#{abr}' is ambiguous" if strict
				end
			end
		end
	end

	private
	def ary_to_h ary
    Hash[ary.map { |w| [w, nil ] }]
	end

	def stringify_h h
	  Hash[h.map do |k,v|
		  [ k.to_s, v ? v.to_s : v ]
		end]
	end

	def safe_merge! hash
	  @table.merge! stringify_h(hash) do |k|
		  raise ArgumentError, "`#{k}' already defined."
		end
	end
end

Thesaurus.log_to $stdout

t = Thesaurus.new "refresh", "trigger", "restore", on: "trigger", thing: "object"
puts t.instance_eval { @table }.inspect

puts "THIS: #{t["re"]}"
