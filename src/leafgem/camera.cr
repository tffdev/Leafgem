class Leafgem::Camera
  property pos = Vec2f.new(0.0, 0.0)
  property posbuffer = Vec2f.new(0.0, 0.0)
  property smooth = false

  def update
    @pos = @posbuffer
  end
end
