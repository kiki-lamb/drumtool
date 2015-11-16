module DrumTool
	module Preprocessors
	  module Stages
		  class Base
			  attr_accessor :pp

			  def initialize pp
				  self.pp = pp
				end
				
				def method_missing name, *a
				  if pp.respond_to? name
					  pp.send name, *a
				  elsif pp.class.respond_to? name
					  pp.class.send name, *a
					else
					  super
					end
				end
			end
		end
	end
end