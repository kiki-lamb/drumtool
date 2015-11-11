require "./lib/drum/top_bubble"

class Drum
	tb = TopBubble.build do
		loop 8

		child do
				loop 5

			  trigger { |t| 0 == t % 4 }

				note 46, :bd
			  note 30, :rs

				child do
				  note 50, :sd
				  trigger { |t| 0 == (t+4) % 8 }
				end
    end

		#B(0..15).each do |tick|
		#	puts "#{self}.events_at(#{tick}) = #{events_at tick}"
    #end
	end

  (0..15).each do |tick|
  	 puts "#{tb}.events_at(#{tick}) = #{tb.events_at tick}"
  end
# 	puts "#{tb}.events_at(0) = #{tb.events_at 0}"
end

