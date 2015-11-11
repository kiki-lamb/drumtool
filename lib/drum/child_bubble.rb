require_relative "./bubble"

class Drum
  class ChildBubble < Bubble
	  local_hash_bubble_attr :notes
		local_array_bubble_attr :triggers
		local_array_bubble_attr :untriggers

  end
end