class Leafgem::Camera
  property pos = NewVec2(Float64).new 0.0, 0.0
  property posbuffer = NewVec2(Float64).new 0.0, 0.0
  property smooth = false

  def update
    @pos = @posbuffer
  end
end
