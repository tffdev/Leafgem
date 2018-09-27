# Vec2 is a struct used for almost all positioning code
# in leafgem
#
# Vec2 takes a Generic
#
# For example:
#
# ```
# Vec2(Int32).new(0, 0)
# ```
#
# This is done to support Floats, Ints, BigInts and so forth.
#
# Vec2 has `#from` to make this a little simpler
#
# ```
# Vec2.from 0, 1 # => Vec2(Int32).new(0,1)
# ```
struct Leafgem::Util::Vec2(T)
  include Enumerable(T)
  include Comparable(T)

  # The x position
  property x : T

  # The y position
  property y : T

  # Automatically determine from the two types
  #
  # ```
  # Vec2.from 0, 1 # => Vec2(Int32).new(0,1)
  # ```
  #
  # Supported multiple types
  #
  # ```
  # Vec2.from 0.3, 10 => Vec2(Float64 | Int32).new(0.3, 10)
  # ```
  def self.from(x, y)
    Vec2(typeof(x) | typeof(y)).new(x, y)
  end

  # Creates a vec2 at position *x*, *y*
  def initialize(@x, @y); end

  def each
    yield x
    yield y
  end

  # Combined comparison operator. Returns 0 if self equals other, 1 if self is greater than other and -1 if self is smaller than other.
  #
  # Adds `#x` and `#y` together and compares the results
  def <=>(other : Vec2)
    @x + @y <=> other.x + other.y
  end

  {% for name in %w(* + / - %) %}

    # Apply {{name.id}} to the Vector
    def {{name.id}}(other)
      Vec2.from(@x {{name.id}} other, @y {{name.id}} other)
    end

    # Apply {{name.id}} with the other Vector
    def {{name.id}}(other : Vec2)
      x1 = @x {{name.id}} other.x
      y1 = @y {{name.id}} other.y

      Vec2.from(x1, y1)
    end

  {% end %}

  # Returns self formatted as a string
  #
  # ```
  # vec = Vec2.from 33, 24
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
  def relative_to_world(scale, offset : Vec2, pos : Vec2)
    return Vec2.from 0.0, 0.0 if scale == 0.0 || offset == 0.0
    (self - offset) / scale + pos
  end

  # position self relative to the world
  def relative_to_world
    self.relative_to_world(Leafgem::Renderer.scale, Leafgem::Renderer.offset, Leafgem::Renderer.camera.pos)
  end
end
