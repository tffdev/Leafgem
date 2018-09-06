class Leafgem::Camera
  property pos = Vec2.new(0, 0)
  property posbuffer = Vec2.new(0, 0)
  property smooth = false

  def update_camera
    @pos = @posbuffer
  end
end
