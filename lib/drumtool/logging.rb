module Logging
  def set_log log
    instance_variable_set :@__log___, log
  end

  def log s
    @__log__ << s.chomp << "\n" if @__log__
  end

  def log_separator char: "=", width: 80
	  log char * width
	end
end