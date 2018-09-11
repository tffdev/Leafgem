require "./hitbox"

class Leafgem::Object
  property pos = Vec2(Float64).new 0.0, 0.0
  property size = Vec2(Int32).new 0, 0
  property hitbox = Hitbox.new(Vec2.from(0, 0), Vec2.from(0, 0))

  def init; end

  def update; end

  def draw; end

  def destroy
    Leafgem::Game.to_destroy.push(self)
  end
end
