module Logging
  def log_to log
    logs << log
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