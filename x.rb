require "./lib/bubbles"

class Bubbles
	tb = bubble do
	  rotate 0

		bubble do
			note :bd, 36
		  trigger { |t| 0 == t % 4 }
		  rotate 0
    end

		bubble do
		  note :sd, 37
		  trigger { |t| 0 == (t+4) % 8 }
		  rotate 1
		end
	end
	
  16.times do
			puts "#{tb.tick} #{tb.tick!}"
  end
end

