class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end

class Fixnum
  def to_bv(length) # 3.to_bv(5) => 00011
    self.to_s(2).rjust(length, '0')
  end
end

