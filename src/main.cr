require "./leafgem"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale
Leafgem::Game.new("Cat Game", 640, 480, 2)

# Define a new "Thing!"
class Player < Leafgem::Object
  @spritesheet = Leafgem::Spritesheet.new("tg.png", 32, 32)

  def init
    set_animation(0..3, 0)
  end

  def update
    @image_speed = 0.05
  end
end

# Create the thing in our game world!
create_object(Player)

Leafgem::Game.run
