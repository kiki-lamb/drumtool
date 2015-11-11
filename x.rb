require "./lib/bubbles"

class Bubbles
	tb = TopBubble.build do
	  rotate 0

		child do
		    rotate 1

			  trigger { |t| 0 == t % 4 }

				note :bd, 36

				child do
				  note :sd, 37
				  trigger { |t| 0 == (t+4) % 8 }
				end
    end
	end
	
  16.times do
			puts "#{tb.tick} #{tb.tick!}"
  end
end

