class Thing
  @spritesheet : SDL::Texture
  @sprquad : SDL::Rect
  @quads = [] of SDL::Rect
  @current_sprite : Float32

  def initialize(sprite_image, sprwidth, sprheight)
    @current_sprite = 0
    @spritesheet = sprite_image
    @sprquad = SDL::Rect[0, 0, sprwidth, sprheight]
    (0..(@spritesheet.height / sprheight) - 1).each do |j|
      (0..(@spritesheet.width / sprwidth) - 1).each do |i|
        @quads << SDL::Rect[i*sprwidth, j*sprheight, sprwidth, sprheight]
      end
    end
  end

  def update
  end

  def draw
  end
end
