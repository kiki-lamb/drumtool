t = 0

# ppq = 24
# bar = ppq * 4
# sixteenth = ppq / 4
# twelfth = ppq / 3
# 
# puts "16th: #{sixteenth}"
# puts "12th: #{twelfth}"
# 
# (ppq * 4).times do
#   $stdout << t
#   $stdout << " (16th ##{t/sixteenth})" if t % sixteenth == 0
#   $stdout << " (12th ##{t/twelfth})" if t % twelfth == 0
#   $stdout << "\n"
#   
#   t += 1
# end
# 



1000.times do |ppq|
  if ppq % 4 == 0 && ppq % 3 == 0
    puts "#{ppq} gives 16ths @ #{ppq/4} ticks and 12ths @ #{ppq/3} ticks"
  end
end



# ppq/4 = 128 ppq/3 = 160 ppq = 512
