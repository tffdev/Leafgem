class Leafgem::AssetManager
  @@sprites = {} of Object.class => SDL::Texture

  def self.image(filename : String) : SDL::Texture
    # This empty string can be replaced with a special Leafgem
    # "no image" image file. Like, black + pink checkerboard lmao
    filename ||= ""
    SDL::IMG.load(filename, Leafgem::Game.renderer)
  end
end

class Leafgem::Spritesheet
  @sprite : SDL::Texture
  @quads = [] of SDL::Rect

  getter sprite
  getter quads

  # How do you make a "Class variable initializer?"
  def initialize(texture : String, width : Int32, height : Int32)
    @sprite = AssetManager.image(texture)
    @quads = Spritesheet.make_quads(@sprite.width, @sprite.height, width, height)
  end

  def self.make_quads(sprite_width : Int32, sprite_height : Int32, width : Int32, height : Int32) : Array(SDL::Rect)
    outputquads = [] of SDL::Rect
    (0..(sprite_height / height) - 1).each do |j|
      (0..(sprite_width / width) - 1).each do |i|
        outputquads << SDL::Rect[i*width, j*height, width, height]
      end
    end
    return outputquads
  end
end
