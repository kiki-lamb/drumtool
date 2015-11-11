require "./lib/bubbles"

class Bubbles
	tb = Bubbles.bubble do
	  rotate 0

		bubble do
		    rotate 0

			  trigger { |t| 0 == t % 4 }

				note :bd, 36

    end

		bubble do
		  rotate 1
		  note :sd, 37
		  trigger { |t| 0 == (t+4) % 8 }
		end

	end
	
  16.times do
			puts "#{tb.tick} #{tb.tick!}"
  end
end

