include "digest"

module Drumtool
  class Reloader
	  attr_reader :filename, :preprocessor, :exception, :exception_lines, :digest, :text

	  def initialize filename, preprocessor: nil
		  filename = filename
			@preprocessor = preprocessor

			@exception = nil
			@exception_lines
			@digest = nil
			@text = nil
		end
	
	  def filename= v
      @filename = v

			@text = File.open(@filename).read

			md5 = Digest::MD5.new
			md5 << @text
			@digest = md5.hexdigest

			@filename
		end
  end
end