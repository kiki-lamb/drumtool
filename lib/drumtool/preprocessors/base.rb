module DrumTool
	module Preprocessors
	  class Base
   		include Logging

			class << self
				def call text
				  new(text).result
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
				  thesaurus[name]
				end

				private
				def thesaurus
				  @thesaurus ||= Thesaurus.new
				end
			end
											
			attr_accessor :text

			def initialize text = ""
			  self.text = text
			end

	    def pad_number num, siz = 4
	      num.to_s.rjust siz, "0" 
	    end

	    def log_separator
	      log "=" * 80
	    end

	    def log_text
	      text.lines.each_with_index do |line, index|
	        log "#{pad_number index} #{line}"
	      end
	    end

	    def result
	      @result ||= begin
					text << "\n"

	      	self.class.stages.each do |sym|
	      	    log_separator
	      	    log "#{self.class.name} performing step: #{sym}"
	      	    log_separator
	      	    
							if respond_to? sym
							  send sym
							else
							  self.text = self.class.send sym, text
							end

	      	    log_separator
	      	    log "#{self.class.name}'s text after performing step: #{sym}"
	      	    log_separator
	      	    log_text
	      	end           

	        text
				end
	    end					       
	  end
	end
end