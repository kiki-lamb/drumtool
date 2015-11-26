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

    def assert_midi_output!
      raise RuntimeError, "Set a MIDI output first." unless @__midi_output__
    end
    
    def __open_note__! note, velocity = 100
      @o_ct ||= 0
      @c_ct ||= 0
      @o_ct += 1
      open_notes.add? note
      midi_output.puts 0x90, note, velocity      
    end

    def send_control! *controls
      assert_midi_output!

      controls.each do |control|
        puts "CC #{control.cc} = #{control.value}"
        midi_output.puts 0xB0, control.cc, control.value
      end
    end
    
    def open_note! *notes, velocity: 100
      assert_midi_output!
      
      close_note! *notes
      
      notes.each do |note|
        if Note === note
          __open_note__! note.number, note.velocity
        else
          __open_note__! note, velocity
        end                        
      end
    end
    
    def __close_note__! note, velocity = 100
      @c_ct ||= 0
      @o_ct ||= 0
      @c_ct += 1
      # puts "CLOSE #{note} @ #{velocity} (#{@o_ct-@c_ct})"
      midi_output.puts 0x80, note, velocity
    end
    
    def close_note! *notes, velocity: 100, force: false
      assert_midi_output!
      
      notes.each do |note|
        if open_notes.delete?(note) || force
          if Note === note
            __close_note__! note.number, note.velocity
          else
            __close_note__! note, velocity
          end                        
        end
      end      
    end
  end
end
