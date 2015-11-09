require "midi"
require "digest"
require "stringio"

module DslAttrs
  def dsl_attr name, after: [], failover: nil
      define_method(name) do |v = nil, &b|
        if v  
          tmp = instance_variable_get("@#{name}")

          instance_variable_set "@#{name}", v
          [*after].each do |after|
            send after
          end
        end

        tmp = instance_variable_get("@#{name}")

        if tmp
        elsif failover
          tmp = send(failover).send(name, v) 
        end

        tmp
      end
  end

  def dsl_toggle name
      define_method(name) do
          instance_variable_set "@#{name}", true
      end
  end
end

class String
  def chunks length
    split('').each_slice(length).map(&:join).to_a
  end
end

class Fixnum
  def to_hex
    tmp = to_s 16
    0 == tmp.length % 2 ? tmp : "0#{tmp}"
  end
end

class Drum
  class << self
    def build &b
      Engine.new.build &b
    end
  end

  class Formatters
    BasicTableFormatter = Proc.new do |rows|
      raise ArgumentError, "Uneven rows" unless rows.map(&:count).uniq.length == 1

      padded = rows.map do |r| 
        r.map! do |c| 
          " #{c.to_s.strip} " 
        end
      end

      widths = padded.map do |r| 
        r.map do |c| 
          c.to_s.length
        end
      end.inject do |l,r| 
        l.zip(r).map do |a| 
          a.max
        end
      end

      spacer = TableRowFormatter.call(widths.map do |w| 
        "=" * w 
      end, widths, separator: '+')

      [ spacer,
        rows.map do |row|
          TableRowFormatter.call row, widths
        end,
        spacer
      ].join "\n"
    end

    MultiTableFormatter = Proc.new do |rowses| 
      raise ArgumentError, "Uneven rows" unless rowses.flatten(1).map(&:count).uniq.length == 1

      padded = rowses.map do |r| 
        r.map do |a| 
          a.map! do |c| 
            " #{c.to_s.strip} "
          end
        end
      end

      widths = padded.flatten(1).map do |r| 
        r.map do |c| 
          c.to_s.length 
        end 
      end.inject do |l,r| 
        l.zip(r).map do |a| 
          a.max
        end
      end

      spacer = TableRowFormatter.call(widths.map do |w| 
        "=" * w 
      end, widths, separator: '+')

      [ 
        *padded.map do |rows|
          [ spacer,
            rows.map do |row|
              TableRowFormatter.call row, widths
            end
          ]
        end,
        spacer
      ].join "\n"
    end

    TableRowFormatter = Proc.new do |values, widths = [], separator: "|"|
      "#{separator}#{values.each_with_index.map do |value, ix|
        value.to_s.ljust(widths[ix] || value.to_s.length)
      end.join "#{separator}" }#{separator}"
    end

    BasicInstrumentFormatter = Proc.new do |range|
      range.map do |t| 
        fires_at? t ? name[0].upcase : "." 
      end.join
    end

    SpacedInstrumentFormatter = Proc.new do |range|
      TableRowFormatter.call(to_s(range, BasicInstrumentFormatter).chunks(4), separator: ' ')
    end

    BasicEngineFormatter = Proc.new do |range|
      instruments.map do |k, v|
        "#{v.name}: #{v.to_s range, InstrumentFormatter}"
      end.join "\n"
    end 

    BasicTableEngineFormatter = Proc.new do |range|
      BasicTableFormatter.call(    
        instruments.map do |k, v|
          [ v.name, *v.to_s(range, SpacedInstrumentFormatter).strip.chunks(20) ]    
        end    
      )
    end

    BasicHeaderBuilder = Proc.new do |lines, body|
        lines.times.map do
           body.first.length.times.map do 
             ""
          end
        end 
    end

    RuleredHeaderBuilder = Proc.new do |body|
       empty = BasicHeaderBuilder.call 2, body
    end

    MultiTableEngineFormatter = Proc.new do |range|
        body = instruments.map do |k, v|
          [ v.short_name, *v.to_s(range, SpacedInstrumentFormatter).strip.chunks(20) ]    
        end    

        fill = TableRowFormatter.call((0..15).map do |x| 
          x.to_s 16 
        end.join.chunks(4), separator: ' ')

        head = RuleredHeaderBuilder.call body

        head[0].each_with_index do |_, ix|
          next if 0 == ix
          head[0][ix] = TableRowFormatter.call (((ix%16)-1).to_s(16) * 16).chunks(4), separator: ' '
        end

        head[1].map! do
          fill      
        end

        head[1][0] = nil

        MultiTableFormatter.call [ head, body ]
    end
  end

  class Instrument
    extend DslAttrs

    dsl_toggle :mute
    dsl_toggle :flip

    dsl_attr :note
    dsl_attr :shift, failover: :collection
    dsl_attr :loop, failover: :collection

    attr_reader :name
    attr_reader :short_name
    attr_reader :collection

    def initialize collection, name
      @name, @note, @loop, @shift, @short_name, @mute, @flip = name, note, nil, nil, name[0..1].upcase, false, false
      @collection, @__triggers__, @__muted_by__ = collection, [], []
      clear_cache
    end

    def build &b
      instance_eval &b
      self
    end

    def clear_cache
      @__cache__ = {}
    end

    def muted_by *names
      names.each do |name|
        @__muted_by__ << name
      end
    end

    def mutes *names
      names.each do |name|
        @collection[name].muted_by name
      end
    end

    def on &condition
     clear_cache
     @__triggers__ << condition
    end

    def fires_at? time
      return false if @mute || (@collection.values.find do |i|
        @__muted_by__.include?(i.name) && i.fires_at?(time)
      end)

      e_time = time - ( shift || 0 )
      e_time %= loop if loop
      
      r = @__cache__[e_time] ||= @__triggers__.find do |t|
        tmp = t.call e_time

        if Fixnum === tmp
          0 == tmp
        else
          tmp
        end
      end

      @flip ? (! r) : r
      
    end

    def to_s range = 0..15, formatter = Formatters::BasicInstrumentFormatter, *a
      if formatter
        instance_exec range, *a, &formatter
      else
        super
      end
    end
  end  

  class Instruments < Hash
    extend DslAttrs

    attr_reader :engine

    # We never actually enter a DSL on this class an are really just using these as 'delegate_to'.
    dsl_attr :shift, failover: :engine
    dsl_attr:loop , failover: :engine

    def initialize engine, *a
      @engine = engine

      super(*a) do |h,k| 
        h[k] = Instrument.new self, k
      end   
    end

    def to_s
      "{#{keys.map do |k| 
        "#{k}=>#{self[k]}"
      end.join ", "}}"
    end   

    def [] k
      super k.to_sym
    end

    def []= k, v
      super k.to_sym, v
    end

    def include? k
      super k.to_sym
    end
  end

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

  class LiveCoder
    def initialize filename, refresh_interval = 16
      @__filename__ = filename
      @__refresh_interval__ = refresh_interval
      @__hash__, @__engine__ = nil, nil
      @exception = false
    end

    attr_reader :exception

    def self.preprocess text
      last_indent = ""
      out = StringIO.new

      text.lines.map(&:chomp).each do |line|
        this_indent = /\s*/.match(line)[0]        
        out << "end\n" if this_indent.length < last_indent.length           
        last_indent = this_indent
        out << "#{(line  
            .gsub /(\s*on\s+)((?:(?:%?\d+)+)(?:\s+(?:%?\d+)+)*)/ do
            r1, r2 = Regexp.last_match[1], Regexp.last_match[2]  
            Regexp.last_match[2].split(/\s+/).map do |n|
              if n[0] == "%"
                "#{r1}{ |t| t#{n} }"
              else
                "#{r1}{ |t| t == #{n} }"
              end
            end.join "\n"
          end
          .gsub /(\s*on\s*$)/ do 
            ""
          end
          .gsub /(\s*on\s+)(?!do)(?!{)(.*)/ do 
            "#{Regexp.last_match[1]}{ |t| #{Regexp.last_match[2]} }"
          end
          .gsub /(\s*instrument\s+)(?!\:)([\w_]*)(?:\s+(\d+))?/ do
            "#{Regexp.last_match[1]}:#{Regexp.last_match[2]} do#{"\n#{last_indent}  note #{Regexp.last_match[3]}" if "" != Regexp.last_match[3].to_s}"  
          end
          .gsub /(\s*muted_by\s+)(?![\:])(.*)/ do
            "#{Regexp.last_match[1]}:#{Regexp.last_match[2]}"
          end
          .gsub /(\s*mutes\s+)(?![\:])(.*)/ do
            "#{Regexp.last_match[1]}:#{Regexp.last_match[2]}"
          end
)}\n" 
      
      end
      
      out << "end\n\n" if last_indent.length > 0
      out.string
    end

    def refresh
      text = File.open(@__filename__).read
      hash = Digest::MD5.new.tap do |d|
        d << text
      end.hexdigest

      if hash != @__hash__
        @__hash__ = hash

        begin
          proc = eval "\nProc.new do\n#{self.class.preprocess File.open("input.rb").read}\nend"
          @exception = nil
          @__engine__ = Drum.build &proc
        rescue Exception => e
          @exception = e
          nil
        end
      end
    end

    def run
        tick = 0

        while true do 
          begin
#           puts "\n\n#{@__engine__.to_s(0..63)}" if (tick%@__refresh_interval__) == 0 && refresh

            refresh if tick%@__refresh_interval__ == 0

            io = StringIO.new
            @__engine__.play tick, log: io
            io << "WARNING: #{@exception.to_s}" if @exception
            $stdout << io.string
          ensure
            tick += 1
          end
        end
      end
  end 
end

puts Drum::LiveCoder.preprocess(File.open("input.rb").read)
lc = Drum::LiveCoder.new("input.rb").run

# Drum.build do
#   shift 7
# 
#   instrument :bd do
#     shift 11
#     puts "=> #{shift}"
#     note 60
#   end
# 
#   instrument :sd do
#     puts "=> #{shift}"
#     note 60
#   end
# end