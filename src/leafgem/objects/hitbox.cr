class Leafgem::Hitbox
  property x = 0
  property y = 0
  property w = 0
  property h = 0

  def initialize(@x = x, @y = y, @w = w, @h = h)
  end

  def set(@x = x, @y = y, @w = w, @h = h)
  end

  def get
    {@x, @y, @w, @h}
  end
end
