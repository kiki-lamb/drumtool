# drumtool
Drum livecoding for Ruby.

DrumTool is an algorithmic MIDI pattern generator intended for livecoding: as you edit a source file in DrumTool's built in language, DrumTool generates MIDI note patterns and sends them to your sequencer of choice in realtime.

DrumTool's DSL's syntax is designed to be concise, for speed during live performance, but more verbose commands can be used if you feel that clarity is more important to you than speed: any unambiguous abbreviation of a valid command will be accepted. You can even ditch vowels, excluding the first one, if you like. For example: 'ref', 'rfr', 'rfrsh' and 'refresh' are all valid shorthand for the 'refresh_interval' command, but 're' isn't since it's ambiguous as it could be confused with the 'reverse' command.

DrumTool uses arirusso's https://github.com/arirusso/topaz and https://github.com/arirusso/unimidi gems for MIDI I/O and synchronization.

DrumTool source code files look like this (or at least, they would look like this if people actually wrote this many comments while performing):

     bpm 112               # If DrumTool isn't hooked up to a MIDI clock,
                           # this is the BPM it will play at.
                           
     lp x40                # Loop the entire track every 4 bars.
     refresh_interval x10  # Reread the code in this file every 1 bar.
     
     # reverse             # Uncommenting this would reverse playback
                           # of the entire track.

     >                     # Instruments in a section only play if the section 
       inst BD 36          # has triggers, so this just sets some default note values
       inst CH 41          # for these instrument names (because when inst is called 
       inst OH 39          # with no note number, it uses the lasts note number given
       inst SD 37          # for that name).
       inst RS 38

     #HEAD

     Content above #HEAD is always processed.

     But this content isn't since it occurs before the #BOF tag.

     #BOF

     > inst BD   # Play the 'BD' instrument
       when %4   # on notes evenly divisible by 4 (every quarter note)
       
     > inst SD   # Play the 'SD' instrument
        when %8  # on notes evenly divisible by 8 (every 8th note)
        shift 4  # shifted back (later in time) by 4/16ths.

     > inst CH   # Play the 'CH' instrument.
       when %4   # on notes evenly divisible by 4 (every quarter note)
       shift 2   # shifted back (later in time) by 2/16ths.
       fl        # Flip triggers coming from this node (play when it
			 					 # would ordinarily not play and vice versa).
       mu        # But it's muted, so we don't hear it.
      
     > inst OH   # Play the 'SD' instrument
       when %4   # on notes evenly divisible by 4 (every quarter note)
       shift 2   # shifted back (later in time) by 2/16ths.

     > inst RS                   # Play the 'RS' instrument
       lp x20                    # looped every 2 bars
       on 1 3 6 10 15 21 28 36   # on ticks landing on some triangular numbers
       off 0..x8                 # but not during the first 8 ticks (half a bar)
       shift 1                   # shifted 1/16th later in time

     > in_scale E minor   # Restrict notes that bubble up from here to an E minor scale.
       lp x40             # Loop for 4 bars

       xform { note(note-time/12); vel(127 - (time * 4)) }
       # ^ Apply arbitrary transformations to notes that bubble up from here.
                                    
       > oct 1    # Transpose notes coming from here up by 1 octave
         lp x08   # Loop this content in this scope every 8 ticks (1/2 a bar).

         > inst SY { num(55 - time / 4) }
         # ^ Play the 'SY' instrument. This call includes an expression to manipulate the
         #   MIDI note number based on the time.
         
         when %5   # Play on notes evenly divisible by 5.
         sh 2      # but play 2/16ths late.

         reverse   # Play this section in reverse
 
     #EOF

     This is after the #EOF tag so it's just extra content that isn't
     going to be processed.

     #RUBY

     message = <<END
     Right now we don't use this content, but in the future, you'll
     be able to write custom ruby code here and reference it within your
     DrumTool script.

     Won't that be cool?
     END

     puts message

DrumTool internally converts your input code into Ruby code that looks like this: 

    self.class.include DrumTool::Models
    Bubbles::Standard.track do 
    bpm(112)
    loop(0x40)
    refresh_interval(0x10)
    child.build do
      note(:BD, 36)
      note(:CH, 41)
      note(:OH, 39)
      note(:SD, 37)
      note(:RS, 38)
    end
    child.build do
      note(:BD)
      trigger((Proc.new { |t| t%4 }))
    end
    child.build do
       note(:SD)
       trigger((Proc.new { |t| t%8 }))
       shift(4)
    end
    child.build do
      note(:CH)
      trigger((Proc.new { |t| t%4 }))
      shift(2)
      flip!
      mute!
    end
    child.build do
      note(:OH)
      trigger((Proc.new { |t| t%4 }))
      shift(2)
    end
    child.build do
      note(:RS)
      loop(0x20)
      trigger(1, 3, 6, 10, 15, 21, 28, 36)
      untrigger((0..0x8))
      shift(1)
    end
    child.build do
      in_scale(:E, :minor)
      loop(0x40)
      xform { note(note-time/12); vel(127 - (time * 4)) }
      child.build do
        octave(1)
        loop(0x08)
        child.build do
          note(:SY) { num(55 - time / 4) }
          trigger((Proc.new { |t| t%5 }))
          shift(2)
        end
      end
    end
    end 

Right now the preprocessor used to do this is regex based and a little ugly, but soon it will be replaced with a proper PEG-based parser... just as soon as someone can recommend a good parsing gem to me. Let me know if you've got ideas.

As it plays back your track, DrumTool produces output like this to help you see what's going on and plan your next move:

     Begin playback of input/new.dt2
     Waiting for MIDI clock #<UniMIDI::Input:0x007f8a292d0b58>...
     Control-C to exit

     | Bar  1 | T-1 bars | 27.001 ms | BD 36 | _____ | _____ | _____ | _____ | _____ | 112 | 0000 |    0 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0001 |    1 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 66 | 112 | 0002 |    2 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0003 |    3 |
     | Bar  1 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 0004 |    4 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0005 |    5 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   |   .   | 112 | 0006 |    6 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 64 | 112 | 0007 |    7 |
     | Bar  1 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | _____ | _____ | 112 | 0008 |    8 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0009 |    9 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 66 | 112 | 000a |   10 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   | RS 38 |   .   | 112 | 000b |   11 |
     | Bar  1 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 000c |   12 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 000d |   13 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   |   .   | 112 | 000e |   14 |
     | Bar  1 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 64 | 112 | 000f |   15 |
     -----------------------------------------------------------------------------------------------------
     | Bar  2 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | RS 38 | _____ | 112 | 0010 |   16 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0011 |   17 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 66 | 112 | 0012 |   18 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0013 |   19 |
     | Bar  2 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 0014 |   20 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0015 |   21 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   | RS 38 |   .   | 112 | 0016 |   22 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 64 | 112 | 0017 |   23 |
     | Bar  2 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | _____ | _____ | 112 | 0018 |   24 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0019 |   25 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 64 | 112 | 001a |   26 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 001b |   27 |
     | Bar  2 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 001c |   28 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   | RS 38 |   .   | 112 | 001d |   29 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   |   .   | 112 | 001e |   30 |
     | Bar  2 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 62 | 112 | 001f |   31 |
     -----------------------------------------------------------------------------------------------------
     | Bar  3 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | _____ | _____ | 112 | 0020 |   32 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0021 |   33 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 64 | 112 | 0022 |   34 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0023 |   35 |
     | Bar  3 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 0024 |   36 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0025 |   37 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   |   .   | 112 | 0026 |   38 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 62 | 112 | 0027 |   39 |
     | Bar  3 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | _____ | _____ | 112 | 0028 |   40 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0029 |   41 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 64 | 112 | 002a |   42 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   | RS 38 |   .   | 112 | 002b |   43 |
     | Bar  3 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 002c |   44 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 002d |   45 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   |   .   | 112 | 002e |   46 |
     | Bar  3 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 62 | 112 | 002f |   47 |
     -----------------------------------------------------------------------------------------------------
     | Bar  4 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | RS 38 | _____ | 112 | 0030 |   48 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0031 |   49 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 62 | 112 | 0032 |   50 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0033 |   51 |
     | Bar  4 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 0034 |   52 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0035 |   53 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   | RS 38 |   .   | 112 | 0036 |   54 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 60 | 112 | 0037 |   55 |
     | Bar  4 | T-1 bars |      0 ms | BD 36 | _____ | _____ | _____ | _____ | _____ | 112 | 0038 |   56 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 0039 |   57 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   | SY 62 | 112 | 003a |   58 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   |   .   | 112 | 003b |   59 |
     | Bar  4 | T-1 bars |      0 ms | BD 36 | _____ | _____ | SD 37 | _____ | _____ | 112 | 003c |   60 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   | RS 38 |   .   | 112 | 003d |   61 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   | OH 39 |   .   |   .   |   .   | 112 | 003e |   62 |
     | Bar  4 | T-1 bars |      0 ms |   .   |   .   |   .   |   .   |   .   | SY 59 | 112 | 003f |   63 |

DrumTool is at an early stage of development - it isn't the most user friendly tool in the world yet, and there are still plenty of bugs to work out.

As time goes by, you'll be able to hear more demos and jam sessions using this software on my Soundcloud at https://soundcloud.com/kiki_lamb, so feel invited to check there for new stuff periodically.