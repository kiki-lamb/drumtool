#            X|X|X|X|X|X|X|X|X|X|X|X|
# zpad 2     X .|X .|X .|X .|X .|X .|
# read 4     X . X .|X . X .|X . X .| 
# zpad 6     X . X . . .|X . X . . .|
 
#            X|
# zpad 2     X .|
# read 4     X . X .|
# zpad 6     X . X . . .|

require 'stringio'

class Looper
  def initialize d = "x"
	  @d = d
  end

	def pad count
	  @d = @d.ljust(count, '.')
  end

	def at tick
	  @d[tick % @d.length]
	end

	def read len
	  @d = to_s len
  end

	def to_s len
	  r = StringIO.new

		len.times do |tick|
		  r << at(tick)
		end

		r.string
  end
end


# l = Looper.new
# l.pad 2
# l.read 4
# l.pad 6
# puts l.to_s 16

l = Looper.new

puts (Looper.new.instance_eval do
  pad 2
  read 4
  pad 6
end)


puts Looper.new((Looper.new.instance_eval do
  pad 2

end).to_s(4))