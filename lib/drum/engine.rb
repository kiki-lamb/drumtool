require "midi"
require_relative "../dsl_attrs"
require_relative "instruments"
require_relative "instrument"
require_relative "formatters"

class Drum
  class Engine
    extend DslAttrs

    dsl_attr :shift
    dsl_attr :loop
    dsl_attr :bpm, after: :tick_length 

    attr_reader :instruments, :output

    def initialize bpm = 128, output = UniMIDI::Output[0]
      @bpm, @instruments, @loop, @shift = bpm, Instruments.new(self), nil, 0
      @output = output
    end

    def play tick, log: $stdout       
        log << "\n" if 0 == (tick % (loop ? [16, loop].min : 16))
        log << "\n"
        log << bpm

        tick = tick % loop if loop
        
        log << Drum::Formatters::TableRowFormatter.call([ 
          tick.to_s(16).rjust(16, "0"), 
          *instruments.values.map do |i| 
            i.fires_at?(tick) ? "#{i.short_name}" : "--" 
          end 
        ], [], separator: " | ")

        notes, length = triggers_at(tick).map(&:note), tick_length

        MIDI.using(output) do 
            play *notes, length
        end
    end

    def build &b
      instance_eval &b
      self
    end

    def tick_length
      @tick_length ||= 60.0/bpm/4
    end

    def triggers_at time
      instruments.values.select do |i|
        i.fires_at? time
      end
    end

    def to_s range = 0..15, formatter = Formatters::MultiTableEngineFormatter, *a
      if formatter
        instance_exec range, *a, &formatter
      else
        "<#{self.class.name} #{instruments}>"
      end
    end

    def instrument name, &b 
      raise ArgumentError, "Need block" unless block_given?

      instruments[name].build &b 
    end                   
  end
end