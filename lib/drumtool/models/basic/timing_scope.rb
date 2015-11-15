module DrumTool
	module Models
		module Basic
		  class TimingScope
			  def self.included(base)
				  base.extend(ClassMethods)
				end

				module ClassMethods
					include DslAttrs
        end

				extend DslAttrs

		    attr_reader :parent
		    attr_accessor :subscopes

		    def top
		      obj = self
		      while (next_obj = obj.parent) != nil do
		          obj = next_obj 
		      end
		      obj
		    end

		    def method_missing name, *a, &b
		      parent.send name, *a, &b
		    end

		    def build &b
		      instance_eval &b if b
		      self
		    end

		    def instruments
		      subscopes.map(&:instruments).flatten + @__hash__.values
		    end

		    def events_at time
					# time = time % loop if loop # NOT SURE IF THIS SHOULD BE WORKED BACK IN?

		      instruments.map do |i|
		        i.fires_at?(time) || nil
		      end.compact
		    end

		    def instrument name, note = nil, &b 
		      if block_given?
		        i = @__hash__[name]
		        i.note note if note
		        i.build &b 
		      end
		    end                   

		    def initialize p = nil, &b
		      @parent = p
					@parent.subscopes << self if @parent

		      @rotate, @shift, @loop, @instruments, @subscopes = 0, 0, nil, nil, []
		      
		      @__hash__= Hash.new do |h,k| 
		        h[k] = Instrument.new self, k
		      end   

					build &b if b
		    end

		    def keys
		      @__hash__.keys
		    end

		    def [] k
		      @__hash__[k.to_sym]
		    end

		    def []= k, v
		      @__hash__[k.to_sym] = v
		    end

		    def include? k
		      @__hash__.include? k.to_sym
		    end

			  dsl_scope_klass TimingScope

				def dsl_scope_klass_init_args
					[ self ]
				end

				# These two are only externally significant on the topmost TimingScope.
		    dsl_attr :refresh_interval, scopable: false
		    dsl_attr :bpm, scopable: false

		    dsl_toggle :mute, up: :parent
		    dsl_toggle :flip, up: :parent

		    additive_dsl_attr :rotate, up: :parent
		    additive_dsl_attr :shift,  up: :parent
		    additive_dsl_attr :scale,  up: :parent
		    dsl_attr(         :loop,   up: :parent) do |v|
		      0 == v ? nil : v
		    end   
		  end
		end
	end
end