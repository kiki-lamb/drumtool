require "digest"
require "stringio"
require "topaz"

module DrumTool
	class LiveCoder
	  class << self
	    def play *a
	      new(*a).play
	    end
	  end

	  attr_reader :exception, :engine

	  def initialize filename, refresh_interval: 16, preprocessor: Preprocessors::Preprocessor, logger: nil, pp_logger: nil, rescue_eval: true, output: UniMIDI::Output[0], clock: nil, reset_on_clock_stop: true
	    @filename, @refresh_interval, @__preprocessor__, @logger, @pp_logger, @rescue_eval = filename, refresh_interval, preprocessor, logger, pp_logger, rescue_eval
	    @__hash__, @engine, @__exception_lines__ = nil, Models::Basic.build, nil
	    @old_engine = nil
	    @exception = false
	    @last_line_length = 2
			@__clock__ = clock
			@__reset_on_clock_stop__ = reset_on_clock_stop
	  end

	  def play
	    tick = 0

	    refresh_t = nil

	    started_tick = Time.now

			refresh

			clock = Topaz::Clock.new(@__clock__ ? @__clock__ : engine.bpm, interval: 16) do
	      begin
	        begin
	          @__exception_lines__ = [] unless exception
	          @logger.flush if @logger
	          @pp_logger.flush if @pp_logger

	          io = StringIO.new
	          
	          if engine.loop && 0 == tick % engine.loop && engine.loop != 1
	            io << "=" * (@last_line_length-2) << "\n"
	          elsif 0 == tick % 16 
	            io << "-" * (@last_line_length-2) << "\n"
	          end

	          refresh_time = Time.now
	          refresh if (tick%@refresh_interval == 0)
						refresh_time = (Time.now - refresh_time) * 1000

						clock.tempo = engine.bpm unless @__clock__
	        
	          io << refresh_time.to_s[0..4].ljust(5,"0") << " | "

	          engine.play(tick, log: io) do
	             tmp = [ (engine.tick_length - (Time.now - started_tick)), 0 ].max
	             @__exception_lines__.unshift "DROPPED A TICK!" if 0 == tmp
	             tmp
	          end if engine
	          started_tick = Time.now

	          io << "\b#{@__exception_lines__[tick%(@engine.loop || 16)]}\n" if @__exception_lines__.any?

	          @last_line_length = io.string.length

	          $stdout << io.string
	        rescue Interrupt
	          raise
	        rescue Exception => e
	          unless @rescue_eval
	            puts "\n\n"
	            raise e 
	          end
	          engine.close_notes if engine
	          @exception = e
	          @__exception_lines__ = [ "WARNING: #{@exception.to_s}", *@exception.backtrace, "" ]
	          @engine = @old_engine
	          @refresh_interval = @engine.refresh_interval || @refresh_interval
	          nil
	        end
	      ensure
	        tick += 1
	      end
	    end

			clock.event.stop do 
			  puts "STOP"
				tick -= tick % engine.loop if @__reset_on_clock_stop__ and engine.loop
			  engine.close_notes
			end

			puts "Waiting for MIDI clock...\nControl-C to exit\n" unless @__clock__.nil?
			
  		clock.start

	  rescue Interrupt
	    engine.close_notes if engine
	    $stdout << "\n#{self.class.name}: Stopped by user.\n"
	  end

	  private
	  def refresh
	    text = File.open(@filename).read
	    hash = Digest::MD5.new.tap do |d|
	      d << text
	    end.hexdigest

	    if hash != @__hash__
	      @__hash__ = hash
	      proc = eval "\nProc.new do\n#{@__preprocessor__.call File.open("#{@filename}").read, logger: @pp_logger}\nend"
	      @exception = nil
	      @old_engine = @engine
	      @engine = Models::Basic.build(&proc).inherit @old_engine
	      @refresh_interval = @engine.refresh_interval || @refresh_interval
	    end
	  end
	end 
end