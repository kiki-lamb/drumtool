module DrumTool
  class FilePlayback < Playback
    def initialize filename, *a, preprocessor: Preprocessors::Preprocessor, **b
		  super *a

			@filename = filename
			@preprocessor = preprocessor
		end

		def engine
		  @engine ||= eval @preprocessor.call(File.open(@filename).read)
		end
  end
end