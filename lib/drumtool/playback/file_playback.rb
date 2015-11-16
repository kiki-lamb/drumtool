module DrumTool
  class FilePlayback < Playback
    def initialize filename, *a, preprocessor: Preprocessors::BasicPreprocessor, **b
		  super *a
			@filename = filename
			@preprocessor = preprocessor
		end

		private
		def engine
		  @engine ||= eval @preprocessor.call(File.open(@filename).read)
		end
  end
end