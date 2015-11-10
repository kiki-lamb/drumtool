require "set"
require "unimidi"
require_relative "../dsl_attrs"
require_relative "timing_scope"
require_relative "instruments"
require_relative "instrument"
require_relative "formatters"

class Drum
  class Engine
    extend DslAttrs

    include TimingScope

    dsl_attr :refresh_interval
    dsl_attr :bpm, after: :tick_length 

		attr_reader :output

    def initialize bpm = 128, output = UniMIDI::Output[0]
      super nil
      @bpm, @loop, @shift, @rotate = bpm, nil, 0, 0
      @output = output
      @open_notes = Set.new
    end

    def play tick, log: $stdout       
        log << bpm

        tick = tick % loop if loop

        log << Drum::Formatters::TableRowFormatter.call([ 
          tick.to_s(16).rjust(16, "0"), 
          *instruments.values.map do |i| 
            i.fires_at?(tick) ? "#{i.short_name}" : "--" 
          end 
        ], [], separator: " | ") << "\n"


        notes, length = triggers_at(tick).map(&:note), tick_length

        notes.each do |note|
          open_note note, length
        end

    ensure
        sleep ( block_given?? yield : tick_length )
        close_notes
    end

    def close_notes
      @open_notes.each do |note|
        close_note note
      end       
    end

    def open_note note, length = tick_length, velocity = 100 # length is currently ignored.
      close_note note, velocity
      @open_notes.add? note
      @output.puts 0x90, note, velocity
    end

    def close_note note, velocity = 100
      @output.puts 0x80, note, velocity if @open_notes.delete? note     
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

    def to_s range = 0..15, formatter = nil # Formatters::MultiTableEngineFormatter, *a
      if formatter
        instance_exec range, &formatter
      else
        super()
      end
    end
  end
end