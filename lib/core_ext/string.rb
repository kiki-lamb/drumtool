class String
  def chunks length
    split('').each_slice(length).map(&:join).to_a
  end
end
