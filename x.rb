require "./lib/drum/top_bubble"

class Drum
	tb = TopBubble.build do

		child do
				loop 8
			  trigger { |t| 0 == t % 4 }

				note 46, :bd

				child do
				  loop 8
				  note 50, :sd
				  trigger { |t| 0 == (t+4) % 8 }
				end
    end
	end

  (0..15).each do |tick|
			tb.tick tick
  	  puts "#{tb}.events(#{tick}) => #{tb.events}"
  end
end

