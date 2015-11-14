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

	  def initialize filename, refresh_interval: 16, preprocessor: Preprocessors::Preprocessor, logger: nil, pp_logger: nil, rescue_eval: true, output: UniMIDI::Output[0], clock: nil, reset_loop_on_stop: true
	    @filename, @refresh_interval, @preprocessor, @logger, @pp_logger, @rescue_eval = filename, refresh_interval, preprocessor, logger, pp_logger, rescue_eval
	    @hash, @engine, @exception_lines = nil, Models::Basic.build, nil
	    @old_engine = nil
	    @exception = false
	    @last_line_length = 2
			@clock = clock
			@reset_loop_on_stop = reset_loop_on_stop
	  end

	  def play
	    tick = 0

	    refresh_t = nil

	    started_tick = Time.now

			refresh

			clock = Topaz::Clock.new(@clock ? @clock : engine.bpm, interval: 16) do
	      begin
	        begin
	          @exception_lines = [] unless exception
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

						clock.tempo = engine.bpm unless @clock
	        
	          io << refresh_time.to_s[0..4].ljust(5,"0") << " | "

	          engine.play(tick, log: io) do
	             tmp = [ (engine.tick_length - (Time.now - started_tick)), 0 ].max
	             @exception_lines.unshift "DROPPED A TICK!" if 0 == tmp
	             tmp
	          end if engine
	          started_tick = Time.now

	          io << "\b#{@exception_lines[tick%(@engine.loop || 16)]}\n" if @exception_lines.any?

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
	          @exception_lines = [ "WARNING: #{@exception.to_s}", *@exception.backtrace, "" ]
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
				tick -= tick % engine.loop if @reset_loop_on_stop and engine.loop
			  engine.close_notes
			end

			puts "Waiting for MIDI clock...\nControl-C to exit\n" unless @clock.nil?
			
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

	    if hash != @hash
	      @hash = hash
	      proc = eval "\nProc.new do\n#{@preprocessor.call File.open("#{@filename}").read, logger: @pp_logger}\nend"
	      @exception = nil
	      @old_engine = @engine
	      @engine = Models::Basic.build(&proc).inherit @old_engine
	      @refresh_interval = @engine.refresh_interval || @refresh_interval
	    end
	  end
	end 
end