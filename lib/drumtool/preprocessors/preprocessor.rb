module DrumTool
  module Preprocessors
    class Preprocessor < Base
        abbreviate \
          :flip,
          :instrument,
          :loop,
          :mute, 
          :refresh_interval,
          :rotate,
          :scale,
          :shift,
          :trigger,
          :untrigger,
          loop: :scope,
          trigger: [ :when, :on ],
          untrigger: [ :not, :except, :exclude ]
		end
	end
end
