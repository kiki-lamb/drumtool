require "./lib/drumtool"

class Booper
  prepend DrumTool::Models::Bubbles::Traits::WithThesaurus

  
  abbreviate def bang
    puts "BANGBANGBANG"
  end

  synonymize def boop
    puts "BOOP!"
  end, :poob
  
end

b = Booper.new

