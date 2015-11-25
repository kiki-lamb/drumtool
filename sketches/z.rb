require "./lib/drumtool";
include DrumTool::Models::Bubbles::Traits::Events::MIDINotes::Helpers::ScaleNotes;
include DrumTool::Models::Bubbles::Traits::Events::MIDINotes::Transform::ToScale;

puts "C  #{scale_notes("C")} => #{map_for_scale(0, scale_notes("C"), 1).inspect}"
puts "D  #{scale_notes("D")} => #{map_for_scale(0, scale_notes("D"), 1).inspect}"
puts "Du #{scale_notes("D")} => #{map_for_scale(2, scale_notes("D"), 1).inspect}"





# C  [0, 2, 3, 5, 7, 8, 10] => [0, 2, 2, 3, 5, 5, 7, 7, 8, 10, 10, 12]
# D  [0, 2, 4, 5, 7, 9, 10] => [0, 2, 2, 4, 4, 5, 7, 7, 9, 9, 10, 12]
# Du [2, 4, 5, 7, 9, 10, 12] => [2, 2, 2, 4, 4, 5, 7, 7, 9, 9, 10, 12]
# Du [2, 4, 5, 7, 9, 10, 12] => [2, 2, 4, 4, 5, 7, 7, 9, 9, 10, 12, 12]
