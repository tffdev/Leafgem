require "../../src/leafgem"
include Leafgem::Library

require "./scene_manager"

class Player < Leafgem::GameObject
  @onground = false

  # animations
  Anim::Idle = [[0, 1], 0, 0.05]

  def init
    set_spritesheet("examples/demo/images/cat.png", 27, 27)

    # idle animation
    set_animation(Anim::Idle)

    set_hitbox(8, 12, 10, 15)
  end

  def update
    @onground = false
    @x -= key?("left") ? 1 : 0
    @x += key?("right") ? 1 : 0
    @y -= key?("up") ? 1 : 0
    @y += key?("down") ? 1 : 0

    set_camera_x(lerp(camera_x, Math.max(@x - 90, 0), 0.05))

    # haha "collision"
    while (meeting_tile_layer?(0, 0, 0))
      @y -= 0.2
      @onground = true
    end
    @y += 1

    if (mpos = Mouse.position)
      debug mpos.x
      debug mpos.y
    end
  end

  def draw
    draw_self
  end
end

set_window("Leafgem Demo!", 560, 400, 2, true)

debug_show_hitboxes(true)

# this function is still a work in progress
load_map("examples/demo/map")
set_camera_x(32)
create_object(Scene_manager, 0, 0)
create_object(Player, 122, 100)

Leafgem::Game.run
