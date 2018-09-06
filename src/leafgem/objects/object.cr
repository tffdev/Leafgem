class Leafgem::GameObject < Leafgem::DrawnObject
  property position : Vec2
  property w = 0
  property h = 0
  property hitbox = Hitbox.new(Vec2[0, 0], 0, 0)

  def initialize
    @position = Vec2[0, 0]
  end

  def init
  end

  def update
  end
end
