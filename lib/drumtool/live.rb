require "stringio"

module DrumTool
  class Live < Playback
    def initialize(
		  filename,
      *a, 
      reload_interval: 1, 
      rescue_exceptions: true,
			**b
    )
		  super filename, *a, **b

      @reload_interval = reload_interval
			@last_reload_time = nil
		  @reloader = Loader.new(filename, @preprocessor, rescue_exceptions: rescue_exceptions)
			@reloader.after do |to| 
			    @clock.tempo = to.bpm if to.bpm && @clock unless @input_clock
			    to.bpm @clock.tempo unless to.bpm
				  @reload_interval = to.refresh_interval
			end
    end

		def engine
		  @reloader.payload
		end

		private
		def tick
		  reload		  
			super
		end

		def reload
		  if @tick % @reload_interval == 0
		    @last_reload_time = @reloader.reload 
			else
			  @last_reload_time = 0
      end
		end
		
		def a_bunch_of_logging_crap
		  reload_time = 0
      io = super
      io << "\b#{@reloader.exception_lines[@tick%(engine.loop || 16)]}\n" if @reloader.exception_lines.any?
      "#{@last_reload_time.to_s[0..4].ljust(5,"0")} | #{io.strip}"
		end
  end 
end