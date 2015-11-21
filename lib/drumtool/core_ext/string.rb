class String
  def chunks length
    split('').each_slice(length).map(&:join).to_a
  end

  def shitty_camelize
    split(/_+/).map(&:capitalize).join
  end

  def shitty_underscore
    gsub(/(?<!^)([A-Z])/) { |x| "_#{Regexp.last_match[1]}" }.downcase
  end
end
