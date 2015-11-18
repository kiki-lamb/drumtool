module DrumTool
  module Models
    class Bubbles
      class << self
        def track klass = Track,  &b
          klass.new timeline, &b
        end

        def timeline &b
          AbsoluteTime.new &b
        end
      end
    end
  end
end

# Current:
# Base < Instant < RelativeTimeline < Pattern(Triggered, Events, Notes, LanguageHelper)
#                < AbsoluteTimeline < Track(Events, LanguageHelper)                                      

                                       
