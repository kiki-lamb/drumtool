module DrumTool
  class FilePlayback < Playback
    def initialize filename, *a, preprocessor: nil, **b
		  super *a, **b
			@filename = filename
			@preprocessor = preprocessor
		end

		private
		def engine
		  @engine ||= begin
			  text = File.open(@filename).read
				eval (@preprocessor ? @preprocessor.call(text) : text)
			end
		end
  end
end
