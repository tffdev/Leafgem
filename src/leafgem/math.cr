class Vec2
  property x : Int32
  property y : Int32

  def initialize(@x, @y); end
end

class Vec2f
  property x : Float64
  property y : Float64

  def initialize(@x, @y); end
end

# class Vec2Relative
#   property x : Int32
#   property y : Int32

#   @pre_pos = Vec2(0, 0)

#   def initialize(x, y)
#   	@pre_pos = Vec2(x,y)
#   	x = x
#   	y = y
#   end

#   def update
#   	x = @pre_pos.x - Leafgem::Renderer.draw_offset_x
#   end
# end
