require "../leafgem"

set_window("Leafgem Demo!", 640, 480, 2, false)

Leafgem::Map.loadmap("demo/maps/leafmap")

# play_music("demo/choon.mp3")

class Player < Leafgem::Object
  @image_index = new_spritesheet("demo/images/tg.png", 32, 32)

  def init
    set_animation([0, 3], 0, 0.05)
  end

  def update
    @x -= keyboard_check("left") ? 1 : 0
    @x += keyboard_check("right") ? 1 : 0
    @y -= keyboard_check("up") ? 1 : 0
    @y += keyboard_check("down") ? 1 : 0

    # play_sound("demo/yahoo.mp3") if keyboard_check_pressed("a")
    set_camera_x(lerp(camera_x, @x - 90, 0.05))
    set_camera_y(lerp(camera_y, @y - 90, 0.05))
  end

  def draw
    # draw_sprite("demo/images/Tileset.png", 100, 100)
    draw_self
  end
end

class Block < Leafgem::Object
  @image_index = new_spritesheet("demo/images/Tileset.png", 32, 32)

  def init
    set_animation([3], 2, 0.0)
  end

  def draw
    draw_self
  end
end

create_object(Block, 100, 100)
create_object(Player, 100, 100)

def a : Void
  debug("FPS: #{Leafgem::Game.getfps}")
  debug("__Leafgem Demo v0.0.1!__")
  debug("camera_x #{camera_x}")
  debug("Number of players on screen: #{get_objects(Player).size.to_s}")
  debug("Block meeting player: #{get_objects(Block)[0].place_meeting(0, 0, Player)}")
end

set_loop_function(->a)

Leafgem::Game.run
