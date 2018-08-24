require "../leafgem"

set_window("Leafgem Demo!", 560, 400, 2, false)

Leafgem::Map.loadmap("demo/maps/demomap")

class Player < Leafgem::Object
  @image_index = new_spritesheet("demo/images/cat.png", 32, 32)

  def update
    @x -= keyboard_check("left") ? 1 : 0
    @x += keyboard_check("right") ? 1 : 0
    @y -= keyboard_check("up") ? 1 : 0
    @y += keyboard_check("down") ? 1 : 0

    set_camera_x(lerp(camera_x, @x - 90, 0.05))
    # set_camera_y(lerp(camera_y, @y - 90, 0.05))
  end

  def draw
    draw_self
  end
end

def loop : Void
  debug "FPS: #{Leafgem::Game.getfps}"
  debug "__Leafgem Demo v0.0.1!__"
  debug "camera_x #{camera_x}"
  debug "player x #{get_objects(Player)[0].x}"
  debug "player y #{get_objects(Player)[0].y}"
end

set_loop_function(->loop)

create_object(Player, 100, 100)

Leafgem::Game.run
