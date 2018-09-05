require "../leafgem"
require "./scene_manager"

class Player < Leafgem::Object
  def init
    set_spritesheet("demo/images/cat.png", 32, 32)
    @onground = false
  end

  def update
    @onground = false
    @x -= key("left") ? 1 : 0
    @x += key("right") ? 1 : 0
    @y -= key("up") ? 1 : 0
    @y += key("down") ? 1 : 0
    set_camera_x(lerp(camera_x, Math.max(@x - 90, 0), 0.05))

    # haha "collision"
    while (meeting_tile(0, 0, 3))
      @y -= 0.2
      @onground = true
    end

    @y += 1
  end

  def draw
    draw_self
  end
end

set_window("Leafgem Demo!", 560, 400, 2, true)

# this function is still a work in progress
Leafgem::Map.loadmap("demo/map")

create_object(Scene_manager, 0, 0)
create_object(Player, 50, 100)

Leafgem::Game.run
