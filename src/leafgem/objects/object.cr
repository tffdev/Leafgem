class Leafgem::GameObject < Leafgem::DrawnObject
  property x = 0
  property y = 0
  property w = 0
  property h = 0
  property hitbox = Hitbox.new(0, 0, 0, 0)

  def init
  end

  def update
  end
end
