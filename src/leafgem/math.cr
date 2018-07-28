class Vec2
  @@x : Int32?
  @@y : Int32?

  def initialize(@@x = x, @@y = y)
  end

  def self.x
    @@x
  end

  def self.y
    @@y
  end
end
