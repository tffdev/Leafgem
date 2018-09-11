require "./hitbox"

class Leafgem::Object
  property pos = NewVec2(Float64).new 0.0, 0.0
  property size = NewVec2(Int32).new 0, 0
  property hitbox = Hitbox.new(NewVec2.from(0, 0), NewVec2.from(0, 0))

  def init; end

  def update; end

  def draw; end

  def destroy
    Leafgem::Game.to_destroy.push(self)
  end
end
