require "../leafgem"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale, smooth_camera
# having "smooth camera" makes the camera snap to pixel coordinates!
set_window("Leafgem Demo!", 640, 480, 2, true)

# I cant explain this yet
Leafgem::Map.loadmap("demo/maps/leafmap")

# We can have some background music in our game!
# "music" loops by default, and is different from "sound".
# There can only be one music track playing at once.
# play_music("demo/choon.mp3")

# Define a new "Thing!"
class Player < Leafgem::Object
  # We assign our spritesheet to "image_index"
  # We make a new spritesheet by passing three parameters into new spritesheet:
  # The filepath, the width, and the height of each subimage.
  @image_index = new_spritesheet("demo/images/tg.png", 32, 32)

  def init
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

    # Camera movement that hella doesnt work
    set_camera_x(lerp(camera_x, @x - 90, 0.05))
    set_camera_y(lerp(camera_y, @y - 90, 0.05))

    # I want to see what the coordinates of my player is, without
    # having to print to the console 60 times per second.
    # we can use "debug" for this, passing through any text
    # or variable you'd like to monitor in realtime!

    # Even though "debug" boxes are drawn, we can call them anywhere.
    debug("__Leafgem Demo v0.0.1!__")
    debug("camera_x #{camera_x}")
  end

  def draw
    # This is a generic and non-dependant sprite drawing function!
    # We can simply pass a filename and a position into this function,
    # and it will be drawn!
    draw_sprite("demo/images/Tileset.png", 100, 100)

    # We've assigned this object a spritesheet and set an
    # animation right? this function right here draws that
    # for us. We dont need to have this if ayou want to manually
    # draw the sprite or handle the animation yourself.
    draw_self
  end
end

# Create the thing in our game world at (100, 100)!
create_object(Player, 100, 100)

# Our game is set up, so now we can run it! When this is called, we
# enter the gameloop, where all objects are drawn, updated, and
# perform anything you want it to, until the player quits
Leafgem::Game.run
