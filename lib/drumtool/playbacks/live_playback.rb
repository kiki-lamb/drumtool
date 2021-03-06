require "stringio"

module DrumTool
  module Playbacks
  class LivePlayback < FilePlayback
    def initialize(
      *a, 
      reload_interval: 16,
      rescue_exceptions: false, 
      init: nil,
      loader: nil,
      **b
        )
      super *a, **b

      @load_interval = reload_interval
      @last_reload_time = nil
      @last_reload_tick = 0
      @loader = loader || Loaders::Loader.new(@filename, @preprocessor, rescue_exceptions: rescue_exceptions, init: init)
      @loader.after do |to, from|
        to.state = from.state
        @clock.tempo = ( to.bpm || 112) if @clock && ! @input_clock
        @load_interval = to.refresh_interval if to.respond_to?(:refresh_interval)
        @load_interval ||= 16
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
      if time % @load_interval == 0
        @last_reload_time = @loader.reload
        @last_reload_tick = time.to_i unless 0 == @last_reload_time
      else
        @last_reload_time = 0
      end
    end
    
    def log_columns
      reload_time = 0
      unchanged_bars = (((time.to_i-@last_reload_tick.to_i).abs)/16).to_i.abs+1
      reload_bars = (@load_interval/16.0)
      countdown = (reload_bars-((time.to_i-@last_reload_tick.to_i)/16%reload_bars))
      countdown = (countdown%1.0 == 0  ? countdown.to_i : countdown.to_r)

      [ 
        "Bar #{unchanged_bars.to_i.to_s.rjust(2)}", 
        "T-#{countdown} bars",
        "#{@last_reload_time.to_s[0..5].rjust(6)} ms",
        *super,
        ("#{@loader.exception_lines[time%(loop || 16)].to_s.strip}" if @loader.exception_lines.any?),
      ].compact
    end   
  end
  end
end
