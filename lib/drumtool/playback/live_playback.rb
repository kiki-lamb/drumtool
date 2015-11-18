require "stringio"

module DrumTool
  class LivePlayback < FilePlayback
    def initialize(
      *a, 
      reload_interval: 16,
      rescue_exceptions: true, 
			init: nil,
			**b
    )
		  super *a, **b

      @load_interval = reload_interval
			@last_reload_time = nil
			@last_reload_tick = 0
		  @loader = Loader.new(@filename, @preprocessor, rescue_exceptions: rescue_exceptions, init: init)
			@loader.after do |to| 
			    @clock.tempo = to.bpm if to.bpm && @clock unless @input_clock
			    to.bpm @clock.tempo unless to.bpm
				  @load_interval = to.refresh_interval if to.respond_to?(:refresh_interval)
			end
    end

		private
		def engine
		  @loader.payload
		end

		def tick
      reload
      
      @loader.safely_with_payload do
			  super
      end
		end

		def reload
		  if @tick % @load_interval == 0
		    @last_reload_time = @loader.reload
				@last_reload_tick = @tick unless 0 == @last_reload_time
			else
			  @last_reload_time = 0
      end
		end
		
		def log_columns
		  reload_time = 0
			unchanged_bars = (@tick-@last_reload_tick)/16.0
			reload_bars = @load_interval/16.0
			countdown = reload_bars-((@tick-@last_reload_tick)/16%reload_bars)
			countdown = countdown%1.0 == 0  ? countdown.to_i : countdown.to_r

		  [ 
			  @load_interval,
			  "#{unchanged_bars.to_i.to_s.rjust(2)} bars", 
			  "T-#{countdown} bars",
				"#{@last_reload_time.to_s[0..5].rjust(6)} ms",
				*super,
        ("#{@loader.exception_lines[@tick%(engine.loop || 16)].strip}" if @loader.exception_lines.any?),
			].compact
		end		
  end 
end
