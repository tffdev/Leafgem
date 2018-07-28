require "leafgem"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale
Leafgem::Game.new("Leafgem Demo!", 640, 480, 2)

# Define a new "Thing!"
class Player < Leafgem::Object
  @spritesheet = Leafgem::Spritesheet.new("images/tg.png", 32, 32)

  def init
    set_animation([0, 3], 0)
    @image_speed = 0.05
  end

  def update
    # Todo: Movement
  end
end

# Create the thing in our game world!
create_object(Player, 10, 10)

Leafgem::Game.run
