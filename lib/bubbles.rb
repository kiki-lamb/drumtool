class Bubbles
  require_relative "./bubbles/bubble"
  require_relative "./bubbles/musical_bubble"
  require_relative "./bubbles/world_bubble"
  require_relative "./bubbles/triggered_bubble"
  require_relative "./bubbles/child_bubble"

	class << self
	  def bubble klass = WorldBubble,  &b
		  klass.bubble &b
		end
	end
end