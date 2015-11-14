require "digest"

# Reloader("somefile") do |proc, old_object|
#   Models::Basic.build(@output, &proc).inherit old_object
# end

module DrumTool
  class Loader
	  attr_reader :exception, :exception_lines, :payload

	  def initialize filename, preprocessor = nil, rescue_exceptions: true
		  @filename = filename
			@digest = nil
			@text = nil

			@preprocessor = preprocessor || Proc.new { |x| x }
			@rescue_exceptions = rescue_exceptions

			@payload = nil
			@exception = nil
			@exception_lines

			@after = nil

			reload
		end

		def after &b
			raise ArgumentError, "Need block" unless block_given?
			@after = b
			self
		end

		def reload
		  return 0 unless read

		  start = Time.now
			old_payload = payload
			clear_exception

		  begin			  		
				@payload = eval(@preprocessor.call @text) 
			rescue Exception => e
    	  raise e unless @rescue_exceptions
    	  @exception, @exception_lines = e, [ "WARNING: #{e.to_s}", *e.backtrace, "" ]
			end

			if @after
			  if @after.arity == 0 && @exception.nil?
			    @after.()
			  elsif @after.arity == 1 && @exception.nil?
				  @after.(payload)
				elsif @after.arity == 2
				  @after.(old_payload, (payload unless @exception))
        end
      end

			(Time.now - start) * 1000
    end

		private
		def clear_exception
		  @exception, @exception_lines = nil, []
		end

		def read		
			text = File.open(@filename).read
			md5 = Digest::MD5.new
			md5 << text

			if md5.hexdigest != @digest
			  @digest = md5.hexdigest
  		  @text = text
			end
		end
  end
end