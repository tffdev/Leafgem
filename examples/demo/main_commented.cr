require "../leafgem"
require "../leafgem"
require "./scene_manager"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale, smooth_camera
set_window("Leafgem Demo!", 560, 400, 2, true)

# I cant explain this yet! it's unfinished but this loads and renders a tilemap!
# Soon, we'll also be adding (optional) positional object instantiation to map loading!
# (Todo: When we make a room .ini file, we can place objects in there too)
Leafgem::Map.loadmap("demo/map")

# We can have some background music in our game!
# "music" loops by default, and is different from "sound".
# There can only be one music track playing at once.
# play_music("demo/choon.mp3")

# Define a new game object!
# Note that *ALL* displayed gameobjects must inherit from Leafgem::Object
class Player < Leafgem::Object
  # We assign our spritesheet to "sprite"
  # We make a new spritesheet by passing three parameters into new spritesheet:
  # The filepath, the width, and the height of each subimage.

  @spritesheet = new_spritesheet("demo/images/cat.png", 32, 32)

  def update
    # Here's some basic movement!
    # We check if "left" is pressed, if so, reduce x coordinate by 1.
    # note: This is "ternary" syntax, its just a little cleaner than if statements
    @x -= keyboard_check("left") ? 1 : 0
    @x += keyboard_check("right") ? 1 : 0
    @y -= keyboard_check("up") ? 1 : 0
    @y += keyboard_check("down") ? 1 : 0

    # This is how we play samples, or "oneshots", by calling play_sound
    # play_sound("demo/yahoo.mp3") if keyboard_check_pressed("a")

    # We want to see where our player is, so we make the camera follow
    # her around, with a little smoothing using linear interpolation
    set_camera_x(lerp(camera_x, Math.max(@x - 90, 0), 0.05))
  end

  def draw
    # This is a generic and non-dependant sprite drawing function!
    # We can simply pass a filename and a position into this function,
    # and it will be drawn!
    # draw_sprite("demo/images/rabbit.png", 100, 100)

    # We've assigned this object a spritesheet and set an
    # animation right? this function right here draws that
    # for us. We dont need to have this if ayou want to manually
    # draw the sprite or handle the animation yourself.
    draw_self
  end
end

create_object(Scene_manager, 0, 0)

# Place our player in our game world at coordinates (50, 100)!
create_object(Player, 50, 100)

# Our game is set up, so now we can run it! When this is called, we
# enter the gameloop, where all objects are drawn, updated, and
# perform anything you want it to, until the player quits
Leafgem::Game.run
