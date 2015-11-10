require "digest"
require "stringio"
require_relative "./live_coder/preprocessor"

class Drum
  class LiveCoder
    class << self
      def play *a
        new(*a).play
      end
    end

    attr_reader :exception, :engine

    def initialize filename, refresh_interval: 16, preprocessor: Preprocessor, logger: nil, rescue_eval: true
      @__filename__, @__refresh_interval__, @__preprocessor__, @__logger__, @__rescue_eval__ = filename, refresh_interval, preprocessor, logger, rescue_eval
			@__hash__, @engine, @__exception_lines__ = nil, nil, nil
      @exception = false
    end

    def play
      tick = 0

      while true do 
        begin
          refresh if tick%@__refresh_interval__ == 0

          io = StringIO.new
          engine.play tick, log: io if engine
          io << "#{@__exception_lines__[tick%@engine.loop%@__exception_lines__.length]}#{"\n" unless engine}" if @exception
          $stdout << io.string
        ensure
          tick += 1
        end
      end
    rescue Interrupt
      engine.close_notes if engine
      $stdout << "\n#{self.class.name}: Stopped by user.\n"
    end

    private
    def refresh
      text = File.open(@__filename__).read
      hash = Digest::MD5.new.tap do |d|
        d << text
      end.hexdigest

      if hash != @__hash__
        @__hash__ = hash

        begin
          proc = eval "\nProc.new do\n#{@__preprocessor__.call File.open("#{@__filename__}").read, logger: @__logger__}\nend"
          @exception = nil
          @engine = Drum.build &proc
					@__refresh_interval__ = @engine.refresh_interval || @__refresh_interval__
        rescue Exception => e
				  raise e unless @__rescue_eval__
          engine.close_notes if engine
          @exception = e
					@__exception_lines__ = [ "WARNING: #{@exception.to_s}", *@exception.backtrace, "" ]
          nil
        end
      end
    end
  end 
end