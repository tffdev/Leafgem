# Base Vec Class
# Should be used for other 2D vectors
abstract class Vec
  {% for name in %w(* + / - %) %}

    # Apply {{name.id}} to the Vector
    def {{name.id}}(amount)
      self.class.new(@x * amount, @y * amount)
    end

    # Apply {{name.id}} with the other Vector
    def {{name.id}}(other : Vec)
      x1 = @x {{name.id}} other.x
      y1 = @y {{name.id}} other.y

      self.class.new(x1, y1)
    end

  {% end %}

  # NOTE: Returns a Vec2f because it can be .to_i, this is for consistency
  def to_relative
    rel_x = 0
    rel_y = 0
    if (lgr = Leafgem::Renderer.renderer)
      rel_x = (@x/lgr.scale[0] - Leafgem::Renderer.draw_offset_x)/Leafgem::Renderer.scale || 0
      rel_y = (@y/lgr.scale[0] - Leafgem::Renderer.draw_offset_y)/Leafgem::Renderer.scale || 0
    end
    self.class.new(rel_x, rel_y)
  end
end

class Vec2 < Vec
  property x : Int32
  property y : Int32

  def initialize(@x, @y); end

  def initialize(x, y)
    @x = x.to_i
    @y = y.to_i
  end
end

class Vec2f < Vec
  property x : Float64
  property y : Float64

  def initialize(@x, @y); end

  def initialize(x, y)
    @x = x.to_f64
    @y = y.to_f64
  end

  def to_i
    Vec2.new @x.to_i, @y.to_i
  end
end
