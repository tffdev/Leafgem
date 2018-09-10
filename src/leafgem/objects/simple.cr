require "./hitbox"

class Leafgem::Objects::Simple
  property pos : Vec2(Float64) = Vec2(Float64).new(0.0, 0.0)
  property size : Vec2(Float64) = Vec2(Float64).new(0.0, 0.0)
  property hitbox = Hitbox.new(Vec2[0.0, 0.0], Vec2[0.0, 0.0])

  def create; end

  def update; end

  def draw; end

  def destroy
    Leafgem::Game.to_destroy.push(self)
  end
end
