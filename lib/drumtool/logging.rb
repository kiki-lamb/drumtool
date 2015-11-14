module Logging
  def self.included(base)
    base.extend(ClassMethods)
  end

	def log s
	  self.class.log s
	end

  module ClassMethods
  	def log_to *ls
		  ls.each do |log|
			  log = File.open(log, "w") if String === log
  	    logs.push log
      end
  	end

  	def log s
		  s = "#{s.chomp}\n"

  	  logs.each do |log|
			  log << s
			end
  	end

  	def log_separator char: "=", width: 80
		  log char * width
		end

		private
		def logs
		   tmp = instance_variable_get :@__logs__
			 tmp = instance_variable_set :@__logs__, [] unless tmp
			 tmp
		end
  end
end