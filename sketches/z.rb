require "./lib/drumtool";

include DrumTool::Models::Bubbles::Traits::Events::MIDINotes::Helpers::ScaleNotes
include DrumTool::Models::Bubbles::Traits::Events::MIDINotes::Transform::ToScale

puts "Cu- #{scale_notes("C")} => #{map_for_scale(false, "C", :minor, :-).inspect}"; STDOUT.flush
puts "Cr- #{scale_notes("C")} => #{map_for_scale(true , "C", :minor, :-).inspect}"; STDOUT.flush
puts "Cu+ #{scale_notes("C")} => #{map_for_scale(false, "C", :minor, :+).inspect}"; STDOUT.flush
puts "Cr+ #{scale_notes("C")} => #{map_for_scale(true , "C", :minor, :+).inspect}"; STDOUT.flush
puts
puts "Du- #{scale_notes("D")} => #{map_for_scale(false, "D", :minor, :-).inspect}"; STDOUT.flush
puts "Dr- #{scale_notes("D")} => #{map_for_scale(true , "D", :minor, :-).inspect}"; STDOUT.flush
puts "Du+ #{scale_notes("D")} => #{map_for_scale(false, "D", :minor, :+).inspect}"; STDOUT.flush
puts "Dr+ #{scale_notes("D")} => #{map_for_scale(true , "D", :minor, :+).inspect}"; STDOUT.flush


