require "./lib/bubbles"

class Bubbles
	tb = bubble do
	  rotate 0

    bubble do
  		note :bd, 36 do
		  trigger { |t| 0 == t % 4 }
		  rotate 0
    end

		rotate 1 do
			bubble do
			  note :sd, 37
			  trigger { |t| 0 == (t+4) % 8 }
			end
    end
	end
	
  16.times do
			puts "#{tb.tick} #{tb.tick!}"
  end
end

