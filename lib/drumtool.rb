require 'require_all'
require_rel '.'

module DrumTool
  def easy_start(
        preprocessor_klass,
        fail_obj = nil,
        default_filename = nil,
        sync = nil,
        logs: [ "output/livecoder", $stdout ],
        preprocessor_logs: [ "output/preprocessor" ],
        playback_klass: Playbacks::LivePlayback,
        **opts        
      )
    sync &&= UniMIDI::Input[1]
    
    playback_klass.log_to *logs
    preprocessor_klass.log_to *preprocessor_logs

    filename = ARGV[1] || default_filename
    
    $stdout << "Begin playback of " << filename << "\n"
    playback_klass.start filename, preprocessor: preprocessor_klass.new, init: fail_obj, clock: sync, **opts
  end
end

