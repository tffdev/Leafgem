require "sdl/sdl"
require "sdl/image"
require "./leafgem"

# Create the window our game will sit in!
# window_title, window_width, window_height, pixel_scale
Leafgem.new("Cat Game", 640, 480, 2)

# Define a new "Thing!"
class Player < Thing
  @@Sprite = AssetManager.make_spritesheet("tg.png", 32, 34)

  def update
    @current_sprite += 0.06
    if (@current_sprite > 4)
      @current_sprite = 0
    end
  end
end

# Create the thing in our game world!
create_object(Player)

# ======================== #
#        MAIN LOOP         #
# ======================== #

loop do
  case event = SDL::Event.poll
  when SDL::Event::Quit
    break
  end

  # draw all objects
  Leafgem.loop.each do |thing|
    thing.update
  end

  # Set background to black
  Leafgem.renderer.draw_color = SDL::Color[0, 0, 0, 255]
  Leafgem.renderer.clear

  # draw all objects
  Leafgem.loop.each do |thing|
    thing.draw
  end

  # finalise
  Leafgem.renderer.present
end
