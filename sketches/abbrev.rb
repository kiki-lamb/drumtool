require './lib/drumtool'
require 'set'

class Thesaurus
	include Logging

	attr_accessor :min_length, :lookup_syms, :return_syms

	def initialize *abbreviables, min_length: 2, lookup_syms: false, return_syms: false, **synonyms
		self.min_length = min_length
		self.lookup_syms = lookup_syms
		self.return_syms = return_syms

		@table = Hash.new

	  add *abbreviables, **synonyms
	end	

	def add *args, **opts
		safe_merge! ary_to_h args
		safe_merge! opts
	end

	private
	def ary_to_h ary
    Hash[ary.map { |w| [w, nil ] }]
	end

	def stringify_h h
	  h.map do |k,v|
		  { k.to_s => v.to_s }
		end.reduce(:merge)
	end

	def safe_merge! hash
	  @table.merge! stringify_h(hash) do |k|
		  raise ArgumentError, "`#{k}' already defined."
		end
	end
end

Thesaurus.log_to $stdout

t = Thesaurus.new "refresh", "trigger", on: "trigger"
puts t.instance_eval { @table }.inspect