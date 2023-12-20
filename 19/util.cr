struct Range(B, E)
  def covers?(other : Range(B, E))
    return false if !self.covers?(other.begin)

    my_end = self.excludes_end? ? self.end - 1 : self.end
    other_end = other.excludes_end? ? other.end - 1 : other.end
    return (self.begin .. my_end).covers?(other_end)
  end

  def overlaps?(other : Range(B, E))
    return true if other.covers?(self)

    return true if self.covers?(other.begin)

    my_end = self.excludes_end? ? self.end - 1 : self.end
    other_end = other.excludes_end? ? other.end - 1 : other.end
    return (self.begin .. my_end).covers?(other_end)
  end

  def *(other : Range(B, E)) : Range(B, E)
    return [self.begin, other.begin].max .. [self.end, other.end].min
  end

  def -(other : Range(B, E)) : Array(Range(B, E))
    return [] of self if other.covers?(self)
    return [ self ] if !other.overlaps?(self)

    my_end = self.excludes_end? ? self.end - 1 : self.end
    other_end = other.excludes_end? ? other.end - 1 : other.end
    return [ (self.begin .. (other.begin - 1)), ((other_end + 1) .. my_end) ].select{|r| !r.empty? }
  end
end
