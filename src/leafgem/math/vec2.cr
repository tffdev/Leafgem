struct Vec2(T)
  property x : T
  property y : T

  # Initialize a Vector in a more simple manner
  macro [](x, y)
    Vec2(typeof({{x}})).new({{x}}, {{y}})
  end

  def initialize(@x, @y); end

  {% for name in %w(* + / - %) %}

    # Apply {{name.id}} to the Vector
    def {{name.id}}(other)
      self.class(T).new(@x {{name.id}} other, @y {{name.id}} other)
    end

    # Apply {{name.id}} with the other Vector
    def {{name.id}}(other : Vec2)
      x1 = @x {{name.id}} other.x
      y1 = @y {{name.id}} other.y

      self.class(T).new(x1, y1)
    end

  {% end %}

  # Returns self formatted as a string
  #
  # ```
  # vec = Vec2[33, 24]
  # vec.to_s => "x: 33, y: 24"
  # ```
  def to_s
    "x: #{@x}, y: #{@y}"
  end

  {% for name, type in {
                         to_i: Int32, to_u: UInt32, to_f: Float64,
                         to_i8: Int8, to_i16: Int16, to_i32: Int32, to_i64: Int64, to_i128: Int128,
                         to_u8: UInt8, to_u16: UInt16, to_u32: UInt32, to_u64: UInt64, to_u128: UInt128,
                         to_f32: Float32, to_f64: Float64,
                       } %}

    # Returns `self` converted to `Vec2({{type}})`.
    def {{name.id}} : Vec2({{type}})
      Vec2({{type}}).new(@x.{{name.id}}, @y.{{name.id}})
    end
  {% end %}

  # Relative to a scale and an offset
  def relative_to(scale, offset)
    (self / scale) - offset
  end

  # Relative to a scale
  def relative_to_scale(scale)
    self / scale
  end

  # Relative to an offset
  def relative_to_offset(offset : Vec2)
    self - offset
  end
end
