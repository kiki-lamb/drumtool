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

    def initialize filename, refresh_interval: 16, preprocessor: Preprocessor
      @__filename__, @__refresh_interval__, @__preprocessor__ = filename, refresh_interval, preprocessor
      @__hash__, @engine = nil, nil
      @exception = false
    end

    def play
      tick = 0

      while true do 
        begin
#          puts "\n\n#{engine.to_s(0..63)}" if (tick%@__refresh_interval__) == 0 && refresh

          refresh if tick%@__refresh_interval__ == 0

          io = StringIO.new
          engine.play tick, log: io
          io << "WARNING: #{@exception.to_s}" if @exception
          $stdout << io.string
        ensure
          tick += 1
        end
      end
    rescue Interrupt
			engine.close_notes
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
          proc = eval "\nProc.new do\n#{@__preprocessor__.call File.open("#{@__filename__}").read}\nend"
          @exception = nil
          @engine = Drum.build &proc
        rescue Exception => e
				  engine.close_notes
          @exception = e
          nil
        end
      end
    end
  end 
end