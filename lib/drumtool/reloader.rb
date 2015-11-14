require "digest"

# Reloader("somefile") do |proc, old_object|
#   Models::Basic.build(@output, &proc).inherit old_object
# end

module DrumTool
  class Loader
	  attr_reader :exception, :exception_lines, :payload

	  def initialize filename, preprocessor: Preprocessors::Preprocessor, rescue_exceptions: true, &b
		  raise ArgumentError, "Need block" unless block_given?
			@create = b
			
		  @filename = filename
			@digest = nil
			@text = nil

			@preprocessor = preprocessor
			@rescue_exceptions = rescue_exceptions

			@payload = nil
			@exception = nil
			@exception_lines

			reload
		end

		def reload
		  start = Time.now
			create eval("\nProc.new do\n#{@preprocessor.call @text}\nend") if read
			(Time.now - start) * 1000
    end

		private
		def create proc
			clear_exception
		  @payload = @create.call proc, @object
		rescue Exception => e
      raise e unless @rescue_exceptions
      @exception, @exception_lines = e, [ "WARNING: #{e.to_s}", *e.backtrace, "" ]
		end

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