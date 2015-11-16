module DrumTool
  module Preprocessors
    class BubblePreprocessor < Preprocessor


      @abbreviations = Thesaurus.new(
        :bubble,
        :flip,
        :instrument,
        :loop,
        :mute!,
        :note,
        :refresh_interval,
        :rotate,
        :scale,
        :shift,
				:trigger,
				:untrigger,
        bubble: [:pattern, :part, :scope],
        trigger: [ :when, :on ],
        untrigger: [ :not, :except, :exclude ]
	    )

			def procify
			end

			def objectify
			    self.text =  "self.class.include DrumTool::Models\nBubbles.track do \n#{text}\nend"
			end
		end
	end
end
            
						