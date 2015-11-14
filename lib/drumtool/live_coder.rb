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

	  def initialize(
		  filename, 
			clock: nil, 
			log: nil, 
			output: UniMIDI::Output[0], 
			preprocessor: Preprocessors::Preprocessor, 
			preprocessor_log: nil, 
			refresh_interval: 16, 
			rescue_eval: true, 
			reset_loop_on_stop: true
		)
	    @filename = filename
			@refresh_interva = refresh_interval
			@preprocessor = preprocessor
			@log = log
			@preprocessor_log = preprocessor_log
			@rescue_eval = rescue_eval
	    @hash = nil
			@engine = Models::Basic.build
			@exception_lines =  nil
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
	          @log.flush if @log
	          @preprocessor_log.flush if @preprocessor_log

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

		        io << engine.bpm << " | " << @refresh_interval

						fill = tick % 4 == 0 ? "--" : ". "

		        io << Models::Basic::Formatters::TableRowFormatter.call([ 
		          tick.to_s(16).rjust(16, "0"), 
		          
		          *engine.instruments.group_by(&:short_name).map do |name, instrs| 
		            (instrs.any? do |i|
		              i.fires_at?(tick) 
		            end) ? "#{name.ljust(2)}" : fill 
		          end
		        ], [], separator: " | ") << "\n"

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
	      proc = eval "\nProc.new do\n#{@preprocessor.call File.open("#{@filename}").read, log: @preprocessor_log}\nend"
	      @exception = nil
	      @old_engine = @engine
	      @engine = Models::Basic.build(&proc).inherit @old_engine
	      @refresh_interval = @engine.refresh_interval || @refresh_interval
	    end
	  end
	end 
end