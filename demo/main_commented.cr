require "../leafgem"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale, smooth_camera
set_window("Leafgem Demo!", 640, 480, 2, false)

# I cant explain this yet! it's unfinished but this loads and renders a tilemap!
# Soon, we'll also be adding (optional) positional object instantiation to map loading!
# (Todo: When we make a room .ini file, we can place objects in there too)
Leafgem::Map.loadmap("demo/maps/leafmap")

# We can have some background music in our game!
# "music" loops by default, and is different from "sound".
# There can only be one music track playing at once.
# play_music("demo/choon.mp3")

# Define a new game object!
# NB: *ALL* displayed gameobjects must inherit from Leafgem::Object
class Player < Leafgem::Object
  # We assign our spritesheet to "image_index"
  # We make a new spritesheet by passing three parameters into new spritesheet:
  # The filepath, the width, and the height of each subimage.
  @image_index = new_spritesheet("demo/images/tg.png", 32, 32)

  def init
    # The animation is frame 0 to 3 on row 0, running at 0.05 frames per second!
    set_animation([0, 3], 0, 0.05)
  end

  def update
    # Here's some basic movement!
    # We check if "left" is pressed, if so, reduce x coordinate by 1.
    # note: This is "ternary" syntax, its just a little cleaner than if statements
    @x -= keyboard_check("left") ? 1 : 0
    @x += keyboard_check("right") ? 1 : 0
    @y -= keyboard_check("up") ? 1 : 0
    @y += keyboard_check("down") ? 1 : 0

    # This is how we play samples, or "oneshots"
    # play_sound("demo/yahoo.mp3") if keyboard_check_pressed("a")

    # We want to see where our player is, so we make the camera follow
    # her around, with a little smoothing using linear interpolation
    set_camera_x(lerp(camera_x, @x - 90, 0.05))
    set_camera_y(lerp(camera_y, @y - 90, 0.05))
  end

  def draw
    # This is a generic and non-dependant sprite drawing function!
    # We can simply pass a filename and a position into this function,
    # and it will be drawn!
    # draw_sprite("demo/images/Tileset.png", 100, 100)

    # We've assigned this object a spritesheet and set an
    # animation right? this function right here draws that
    # for us. We dont need to have this if ayou want to manually
    # draw the sprite or handle the animation yourself.
    draw_self
  end
end

# We've added a new object "Block"!
# it doesn't *do* anything, but we're checking collisions with this!
# check the debug menu while you're in game and try hovering over it with the player
class Block < Leafgem::Object
  @image_index = new_spritesheet("demo/images/Tileset.png", 32, 32)

  def init
    # I'll replace this with a "set subimage" soon for non animated objects
    set_animation([3], 2, 0.0)
  end

  def draw
    draw_self
  end
end

# Create the thing in our game world at (100, 100)!
create_object(Block, 120, 120)
create_object(Player, 100, 100)

def a : Void
  debug("FPS: #{Leafgem::Game.getfps}")
  debug("__Leafgem Demo v0.0.1!__")
  debug("camera_x #{camera_x}")
  debug("Number of players on screen: #{get_objects(Player).size.to_s}")
  debug("Block meeting player: #{get_objects(Block)[0].place_meeting(0, 0, Player)}")
end

set_loop_function(->a)

# Our game is set up, so now we can run it! When this is called, we
# enter the gameloop, where all objects are drawn, updated, and
# perform anything you want it to, until the player quits
Leafgem::Game.run
