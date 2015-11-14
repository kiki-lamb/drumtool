class Fixnum
  def to_hex
    tmp = to_s 16
    0 == tmp.length % 2 ? tmp : "0#{tmp}"
  end
end
