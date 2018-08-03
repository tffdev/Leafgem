require "../leafgem"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale
set_window("Leafgem Demo!", 640, 480, 3)

Leafgem::Map.loadmap("demo/maps/leafmap")

play_music("demo/choon.mp3")

# Define a new "Thing!"
class Player < Leafgem::Object
  @image_index = new_spritesheet("demo/images/tg.png", 32, 32)

  def init
    set_animation([0, 3], 0, 0.05)
  end

  def update
    # Here's some basic movement!
    @x -= keyboard_check("left") ? 1 : 0
    @x += keyboard_check("right") ? 1 : 0
    @y -= keyboard_check("up") ? 1 : 0
    @y += keyboard_check("down") ? 1 : 0
  end

  def draw
    # Leafgem::Game.set_camera_x(Leafgem::Game.camera_x + 1)
    draw_sprite("demo/images/Tileset.png", 100, 100)
    draw_self
  end
end

# Create the thing in our game world!
create_object(Player, 100, 100)

Leafgem::Game.run
