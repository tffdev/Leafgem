class Leafgem::AssetManager
  @@sprites = {} of String => SDL::Texture

  def self.image(filename : String) : SDL::Texture
    # This empty string can be replaced with a special Leafgem
    # "no image" image file. Like, black + pink checkerboard lmao
    filename ||= ""

    if texture = @@sprites[filename]?
      texture
    else
      @@sprites[filename] = SDL::IMG.load(filename || "", Leafgem::Renderer.renderer)
    end
  end
end

class Leafgem::Spritesheet
  @sprite : SDL::Texture
  @quads = [] of SDL::Rect

  getter sprite
  getter quads

  # How do you make a "Class variable initializer?"
  def initialize(texture_filename : String, width : Int32, height : Int32)
    @sprite = Leafgem::AssetManager.image(texture_filename)
    @quads = Leafgem::Spritesheet.make_quads(@sprite.width, @sprite.height, width, height)
  end

  def self.make_quads(sprite_width : Int32, sprite_height : Int32, width : Int32, height : Int32) : Array(SDL::Rect)
    outputquads = [] of SDL::Rect
    (0..(sprite_height / height)).each do |j|
      (0..(sprite_width / width)).each do |i|
        outputquads << SDL::Rect[i*width, j*height, width, height]
      end
    end
    return outputquads
  end
end
