require "stringio"
require "topaz"
require "unimidi"
require "set"

module DrumTool
  module Playbacks
  class Base
    include Logging
    include MIDI

    class << self
      def start *a
        new(*a).start
      end
    end
    
    def initialize(
      engine = nil,
      clock: nil,
      output: UniMIDI::Output[0], 
      reset_loop_on_stop: true,
      fixed_bpm: 128,
      fixed_loop: 16
        )
      @engine = engine
      @input_clock = clock
      @reset_loop_on_stop = reset_loop_on_stop
      @last_line_length = 0
      set_midi_output output
    end

    def start          
      log "Waiting for MIDI clock #{@input_clock}...\nControl-C to exit\n" if @input_clock
      clock.start
    rescue Interrupt
      close_notes!
    end    

    ################################################################################
    # Engine access
    ################################################################################

    private

    attr_accessor :engine

    def displayed_notes
      #puts "Access engine.displayed_notes"
      engine.displayed_notes || []
    end
    
    def events
      #puts "Access engine.events"
      @last_events = (engine ? engine.events : [])
    end

    def tick!
      #puts "Access engine.tick!"
      engine.tick! if engine
      
      @last_events = nil
    end
    
    def time
      #puts "Access engine.time"
      (engine && engine.time) || 0
    end

    def time= v
      #puts "Access engine.time= v"
      engine.time = v
    end
    
    def loop
      #puts "Access engine.loop"
      engine && engine.loop
    end

    def bpm
      #puts "Access engine.bpm"
      (engine && engine.bpm) || 112
    end
    
    ################################################################################

    def send_or_get v
      case v
      when Array
        v.dup.inject(self) do |o, sym|
          sym[0] == "@" ? o.instance_variable_get(v) : o.send(sym)
        end
      when Symbol
        v[0] == "@" ? instance_variable_get(v) : send(v)
      else 
        v
      end
    end

    def assert_valid_engine!
      raise RuntimeError, "Invalid engine" unless EngineInterface === engine 
    end

    def clock         
      @clock ||= begin
        Topaz::Clock.new((@input_clock ? @input_clock : bpm), interval: 16, &Proc.new { tick }).tap do |c|
          c.event.stop do 
            $stdout << "\n#{self.class.name}: Stopped.\n"
            close_notes!
            self.time = ( time - time%loop ) if loop
          end
        end
      end
    end

    def tick
      close_notes! 
      assert_valid_engine!

      log_sep
      
      open_note! *(events.select do |e|
                     Note === e
                   end)
      
      send_control! *(events.select do |e|
                        Controller === e
                      end)

      puts "#{engine.time} / #{engine.children.first.lores_time} / #{engine.children.first.hires_time}"
      tmp = a_bunch_of_logging_crap.strip
      @last_line_length = tmp.length
      log tmp
      
      tick!
    end

    def log_sep
      io = StringIO.new
      if loop && 0 == time % loop && loop != 1
        io << "=" * (@last_line_length) << "\n"
      elsif 0 == time % 16 
        io << "-" * (@last_line_length) << "\n"
      end
      log io.string unless io.string.empty?
    end

    def log_columns
      fill = time % 4 == 0 ? "_____" : "  .  "
      tail = displayed_notes.map do |note|
        if note
          note.to_s.upcase.ljust(3, " ")
        else
          fill
        end
      end

      [  
         *tail, 
         bpm.to_s.rjust(3),
         (loop ? time % loop : time).to_i.to_s(16).rjust(4, "0"), 
         time.to_s.rjust(4," ")
      ]
    end

    def a_bunch_of_logging_crap
      io = StringIO.new      
      io << Formatters::TableRowFormatter.call(log_columns, [], separator: " | ") << "\n"
      io.string           
    end
  end 
end
end
