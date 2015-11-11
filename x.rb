require "./lib/drum/top_bubble"

class Drum
	tb = TopBubble.build do

		child do
				loop 8
			  trigger { |t| 0 == t % 4 }

				note 46

				child do
				  loop 8
				  note :sd, 50
				  trigger { |t| 0 == (t+4) % 8 }
				end
    end
	end
	
  16.times do
			puts "#{tb.tick} #{tb.tick!}"
  end
end

