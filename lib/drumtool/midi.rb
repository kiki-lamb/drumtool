require "unimidi"
require "set"

module DrumTool
  module MIDI
	  def open_notes
		  @__open_notes__ ||= Set.new
		end

		def midi_output
		  @__midi_output__ ||= nil
		end

		def set_midi_output v
 		  @__midi_output__ = v
		end

    def close_notes!
		  open_notes.each do |note|
		     close_note! note
		   end       
	  end

    def __open_note__! note, velocity = 100
      open_notes.add? note
		  midi_output.puts 0x90, note, velocity      
    end
    
		def open_note! *notes, velocity: 100
		  assert_midi_output!

			close_note! *notes

		  notes.each do |note|
        if Note === note
#          note.process!
          __open_note__! note.number, (note.velocity || velocity)
        else
          __open_note__! note, velocity
        end                        
      end
		end

		def close_note! *notes, velocity: 100, force: false
		  assert_midi_output!

		  notes.each do |note|
		    midi_output.puts 0x80, note, velocity if open_notes.delete?(note) || force
			end
		end

		private
		def assert_midi_output!
		  raise RuntimeError, "Set a MIDI output first." unless @__midi_output__
		end
  end
end
