# drumtool
Drum livecoding for Ruby.

DrumTool is an algorithmic MIDI pattern generator intended for livecoding: as you edit a source file in DrumTool's built in language, DrumTool generates MIDI note patterns and sends them to your sequencer of choice in realtime.

DrumTool uses arirusso's https://github.com/arirusso/topaz and https://github.com/arirusso/unimidi gems for MIDI I/O and synchronization.

DrumTool source code files look like this:

		 bpm 112               
		 lp x40                # Loop every 4 bars.
		 refresh_interval x10  # Refresh the code every 1 bar.

		 >                     # Instruments in a section only play if the section 
		   inst BD 36          # has triggers, so this just sets some default note values
		   inst CH 41          # for certain instruments names (because when inst is called 
		   inst OH 39          # with no note number, it uses the lasts note number given
		   inst SD 37          # for that name).
		   inst RS 38

		 #HEAD

		 Content above #HEAD is always processed.

		 But this content isn't since it occurs before the #BOF tag.

		 #BOF

		 > inst BD             # Play the 'BD' instrument
		   when %4             # on notes evenly divisible by 4 (every quarter note)
		   
		 > inst SD             # Play the 'SD' instrument
		    when %8            # on notes evenly divisible by 8 (every 8th note)
		    shift 4            # shifted back (later in time) by 4/16ths.

		 > inst CH             # Play the 'CH' instrument.
		   when %4             # on notes evenly divisible by 4 (every quarter note)
		   shift 2             # shifted back (later in time) by 2/16ths.
		 	fl		               # Flip the result (play when it would ordinarily not play and vice versa).
		 	mu									 # But it's muted, so we don't hear it.
		 	
		 > inst OH             # Play the 'SD' instrument
		   when %4             # on notes evenly divisible by 4 (every quarter note)
		   shift 2             # shifted back (later in time) by 2/16ths.

		 > inst RS                   # Play the 'RS' instrument
		   lp x20                    # looped every 2 bars
		   on 1 3 6 10 15 21 28 36   # on ticks landing on some triangular numbers
		 	off 0..x8                  # but not during the first 8 ticks (half a bar)
		 	shift 1                    # shifted 1/16th later in time

		 > in_scale E minor    # Restrict notes that bubble up from here to an E minor scale.
		 	 lp x40              # Loop for 4 bars

			 xform { note(note-time/12); vel(127 - (time * 4)) }
			 # ^ Apply arbitrary transformations to notes passing through. 
		 	                              
		   > oct 1             # Transpose notes coming from here up by 1 octave
		 		 lp x08            # Loop this content in this scope every 8 ticks (1/2 a bar).

         > inst SY { num(55 - time / 4) }
         # ^ Play the 'SY' instrument. This call includes an expression to manipulate the
		     #   MIDI note number based on the time.
				 
		     when %5           # Play on notes evenly divisible by %6 (every dotted eighth note)
		 		 sh 2              # 2/16ths late.

		 #EOF

		 This is after the #EOF tag so it's just extra content that isn't going to be processed.

		 #RUBY

		 message = <<END
		 Right now we don't use this content, but in the future, you'll be able to write custom ruby code here
		 and reference it within your DrumTool script.

		 Won't that be cool?
		 END

		 puts message
 
