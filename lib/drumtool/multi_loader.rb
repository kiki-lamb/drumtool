require "digest"

module DrumTool
  class MultiLoader
    attr_reader :exception, :exception_lines
    
    def initialize preprocessor, *filenames, init: nil, rescue_exceptions: false
      @loaders = filenames.map do |filename|
        Loader.new filename, preprocessor, init: init, rescue_exceptions: rescue_exceptions
      end

      clear_exception
      
      @after = nil
    end

    def exception
      @loaders.find(&:exception)
    end

    def exception_lones
      @loaders.find(&:exception).exception_lines
    end
    
    def safely_with_payload &b
      @loaders.first.safely_with_payload &b
    end
    
    def after &b
      raise ArgumentError, "Need block" unless block_given?
      
      @loaders.each do |e|
        e.after &b
      end
    end

    def payload
      reload unless @payload
      @payload
    end

    def reload
      time = @loaders.map(&:reload).inject { |x, y| x + y }  # .tap { |x| "ML.reloaded = #{x}" }.inject { |x,y| x+y }
      @payload = Playbacks::MultiEngine.new *@loaders.map(&:payload)
      time
    end

    private
    def clear_exception
      @exception, @exception_lines = nil, []
    end
  end
end
