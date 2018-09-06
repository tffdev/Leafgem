class Vec2
  property x : Int32
  property y : Int32

  macro [](x, y)
    Vec2.new({{x}}, {{y}})
  end

  def initialize(@x, @y); end
end
