class Vec2
  property x : Int32
  property y : Int32

  def initialize(@x, @y); end

  def to_relative
    rel_x = 0
    rel_y = 0
    if (lgr = Leafgem::Renderer.renderer)
      rel_x = (@x/lgr.scale[0] - Leafgem::Renderer.draw_offset_x)/Leafgem::Renderer.scale || 0
      rel_y = (@y/lgr.scale[0] - Leafgem::Renderer.draw_offset_y)/Leafgem::Renderer.scale || 0
    end
    Vec2.new(rel_x.to_i, rel_y.to_i)
  end

  def *(scale)
    Vec2.new((self.x*scale).to_i, (self.y*scale).to_i)
  end

  def +(other : Vec2)
    Vec2.new((self.x + other.x).to_i, (self.y + other.y).to_i)
  end

  def to_f
    Vec2f.new @x.to_f, @y.to_f
  end
end

class Vec2f
  property x : Float64
  property y : Float64

  def initialize(@x, @y); end

  def initialize(x : Int, y : Int)
    @x = x.to_f64
    @y = y.to_f64
  end

  def to_i
    Vec2.new @x.to_i, @y.to_i
  end
end
