require "digest"

# Reloader("somefile") do |proc, old_object|
#   Models::Basic.build(@output, &proc).inherit old_object
# end


module Drumtool
  class Reloader
	  attr_reader :exception, :exception_lines, :payload

	  def initialize filename, preprocessor: Preprocessors::Preprocessor, rescue_exceptions: true, &b
		  raise ArgumentError, "Need block" unless block_given?
			@create = b
			
		  filename = filename
			@digest = nil
			@text = nil

			reread

			@preprocessor = preprocessor
			@rescue_exceptions = rescue_exceptions

			@payload = nil
			@exception = nil
			@exception_lines
		end

		def reload
		  return unless reread

		  proc = eval "\nProc.new do\n#{@preprocessor.call @text}\nend"

			clear_exception

			payload = create proc
    rescue Exception => e
      raise e unless @rescue_exceptions
      @exception, @exception_lines = e, [ "WARNING: #{@exception.to_s}", *@exception.backtrace, "" ]
    end

		private
		def create proc
		  @create.call proc, @object
		end

		def clear_exception
		  @exception, @exception_lines = nil, []
		end

		def reread		
			text = File.open(@filename).read
			md5 = Digest::MD5.new
			md5 << @text

			if md5.digest != @digest
			  @digest = md5.hexdigest
			  @text = text
			end
		end
  end
end