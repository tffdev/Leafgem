require "../../src/leafgem"
include Leafgem::Library

set_window("Hello world!", 320, 240, 3)

class Preview < Leafgem::GameObject
  def draw
    draw_sprite("examples/hello_world/sprite.png", pos.x, pos.y)
  end
end

create_object(Preview, 10, 10)

Leafgem::Game.run
