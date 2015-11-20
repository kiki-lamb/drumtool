require "digest"

# Reloader("somefile") do |proc, old_object|
#   Models::Basic.build(@output, &proc).inherit old_object
# end

module DrumTool
  class Loader
    attr_reader :exception, :exception_lines, :prior
    
    def initialize filename, preprocessor = nil, init: nil, rescue_exceptions: true
      @filename = filename
      @digest = nil
      @text = nil

      @preprocessor = preprocessor || Proc.new { |x| x }
      @rescue_exceptions = rescue_exceptions
      @payload = init
      @prior = nil
      @exception = nil
      @exception_lines

      @after = nil
    end

    def safely_with_payload &b
      begin
        if b.arity == 0
          b.call()
        else
          b.(self)
        end
      rescue Exception => e
        raise e unless @rescue_exceptions
        
        rollback! e

        if @payload
          if b.arity == 0
            b.call()
          else
            b.(self)
          end
        end
      end
    end
    
    def rollback! e = nil
      self.exception = e if e
#      raise RuntimeError, "Can't rollback to nil" unless @prior
      @payload = @prior
    end
    
    def after &b
      raise ArgumentError, "Need block" unless block_given?
      @after = b
      self
    end

    def payload
      reload unless @payload
      @payload
    end

    def exception= e
      @exception, @exception_lines = e, [ "WARNING: #{e.to_s}", *e.backtrace, "" ]      
    end
    
    def reload
      return 0 unless read
      puts "RELOAD!"
      start = Time.now
      clear_exception

      begin
        tmp_payload = eval(@preprocessor.call @text) 
        @prior = @payload
        @payload = tmp_payload

        if @after
          if @after.arity == 0 && @exception.nil?
            @after.()
          elsif @after.arity == 1 && @exception.nil?
            @after.(@payload)
          elsif @after.arity == 2
            @after.(@payload, @prior)
          end
        end
      rescue Exception => e
        self.exception = e
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
