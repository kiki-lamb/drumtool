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

		include Logging

    def initialize(
      filename, 
      clock: nil, 
      output: UniMIDI::Output[0], 
      preprocessor: Preprocessors::Preprocessor, 
      refresh_interval: 1, 
      rescue_exceptions: true, 
      reset_loop_on_stop: true
    )
      @filename = filename
      @output = output
      @clock = clock

		  @reloader = Reloader.new(@filename, preprocessor: preprocessor, rescue_exceptions: rescue_exceptions) do |proc, old_object|
 			  eng = Models::Basic.build(@output, &proc)
				eng.inherit old_object if old_object
				eng
			end
      
      @refresh_interval = refresh_interval
      @rescue_exceptions = rescue_exceptions
      @reset_loop_on_stop = reset_loop_on_stop

      @last_line_length = 2
    end

		def engine
		  @reloader.payload
		end

		def a_bunch_of_logging_crap tick, refresh_time
      io = StringIO.new
      
      if engine.loop && 0 == tick % engine.loop && engine.loop != 1
        io << "=" * (@last_line_length-2) << "\n"
      elsif 0 == tick % 16 
        io << "-" * (@last_line_length-2) << "\n"
      end

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

      io << "\b#{@reloader.exception_lines[tick%(@engine.loop || 16)]}\n" if @reloader.exception_lines.any?

      @last_line_length = io.string.length

      log io.string
		end

    def play
      tick = 0

      refresh_t = nil

      started_tick = Time.now

      @reloader.reload

      clock = Topaz::Clock.new(@clock ? @clock : engine.bpm, interval: 16) do
        begin
          begin

            refresh_time = Time.now
            @reloader.reload if (tick%@refresh_interval == 0)
            refresh_time = (Time.now - refresh_time) * 1000

						engine.close_notes

 	          clock.tempo = engine.bpm unless @clock

				    a_bunch_of_logging_crap tick, refresh_time
          
            engine.play(tick) do
               tmp = [ (engine.tick_length - (Time.now - started_tick)), 0 ].max
               @exception_lines.unshift "DROPPED A TICK!" if 0 == tmp
               tmp
            end if engine

            started_tick = Time.now
          rescue Interrupt
					  engine.close_notes if engine
            raise
          end
        ensure
          tick += 1
        end
      end

      clock.event.stop do 
        log "STOP"
        tick -= tick % engine.loop if @reset_loop_on_stop and engine.loop
        engine.close_notes
      end

      log "Waiting for MIDI clock...\nControl-C to exit\n" unless @clock.nil?
      
      clock.start

    rescue Interrupt
      engine.close_notes if engine
      $stdout << "\n#{self.class.name}: Stopped by user.\n"
    end    
  end 
end