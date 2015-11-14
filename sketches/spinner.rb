require "curses"
include Curses

################################################################################

frames = []

frames[0] = <<'FRAME'
  000
 00000
 00000
 00000
  000
+=====+
|  |  |
|  0  |
|     |
+=====+
FRAME

frames[1] = <<'FRAME'
  ooo
 o000o
 o000o
 o000o
  ooo
+=====+
|    /|
|  0  |
|     |
+=====+
FRAME

frames[2] = <<'FRAME'
  ...
 .ooo.
 .o0o.
 .ooo.
  ...
+=====+
|     |
|  0--|
|     |
+=====+
FRAME

frames[3] = <<'FRAME'
  
  ooo
  o0o
  ooo
  
+=====+
|     |
|  0  |
|    \|
+=====+
FRAME

frames[4] = <<'FRAME'
  
  ...
  .o.
  ...
  
+=====+
|     |
|  0  |
|  |  |
+=====+
FRAME

frames[5] = <<'FRAME'
  
   
   o 

     
+=====+
|     |
|  0  |
|/    |
+=====+
FRAME

frames[6] = <<'FRAME'
  
   
   . 

     
+=====+
|     |
|--0  |
|     |
+=====+
FRAME

frames[7] = <<'FRAME'
  
   
     
    
     
+=====+
|\    |
|  0  |
|     |
+=====+
FRAME

frames

################################################################################

begin
  init_screen
  crmode
  
  wins = [ Window.new(16, 8, 0, 0), Window.new(16, 8, 0, 9), Window.new(16, 8, 0, 18), Window.new(16, 8, 0, 27) ]

	bpm = 100
	tick_len = 60.0 / bpm / 4
  t = 0
  
  while true do
	  l_start = Time.now

    wins[0].clear
    wins[0].setpos 0, 0
    wins[0].addstr frames[ t % 8 ]
    wins[0].refresh 

    wins[1].clear
    wins[1].setpos 0, 0
    wins[1].addstr frames[ (t*2 % 8) ]
    wins[1].refresh

    wins[2].clear
    wins[2].setpos 0, 0
    wins[2].addstr frames[ (t+4) % 8 ]
    wins[2].refresh 

    wins[3].clear
    wins[3].setpos 0, 0
    wins[3].addstr frames[ (t/2 % 8) ]
    wins[3].refresh

    refresh

    sleep tick_len - (Time.now - l_start)
    t += 1
  end
ensure
  close_screen
end