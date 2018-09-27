require "./hitbox"

# The leafgem base object
class Leafgem::Object
  property pos = Vec2(Float64).new 0.0, 0.0
  property size = Vec2(Int32).new 0, 0
  property hitbox = Hitbox.new(Vec2.from(0, 0), Vec2.from(0, 0))

  # Called when the object is added and initialized
  def init; end

  # Called whenever the object is updated
  def update; end

  # Called when drawing the object
  #
  # Drawing logic should go here
  def draw; end

  # Drestroys self from the `Game`
  def destroy
    Leafgem::Game.to_destroy.push(self)
  end
end
