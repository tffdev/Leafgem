require "sdl/sdl"
require "sdl/image"
require "./things/thing"
require "./things/player"

SDL.init(SDL::Init::VIDEO); at_exit { SDL.quit }
SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }

WINDOW   = SDL::Window.new("Cat Game", 640, 480)
RENDERER = SDL::Renderer.new(WINDOW, SDL::Renderer::Flags::ACCELERATED | SDL::Renderer::Flags::PRESENTVSYNC)

RENDERER.scale = {2, 2}

# create gameloop
LOOP = [] of Thing

AssetManager.setSpriteTable({
  Player => ["tg.png", 32, 34],
} of Thing.class => Array(Int32 | String))

def create_object(thing)
  assetdata = AssetManager.getObjectData(thing)
  spritedata = AssetManager.getSprite(assetdata[0].as(String))
  LOOP << thing.new(spritedata, assetdata[1].as(Int32), assetdata[2].as(Int32))
end

create_object(Player)

class AssetManager
  @@spritetable = {} of Thing.class => Array(Int32 | String)
  @@sprites = {} of String => SDL::IMG

  def self.setSpriteTable(hashes)
    @@spritetable = hashes
  end

  def self.getObjectData(thing : Thing.class)
    @@spritetable[thing]
  end

  def self.getSprite(filename : String)
    filename ||= ""
    SDL::IMG.load(File.join(__DIR__, filename), RENDERER)
  end
end

# ======================== #
#        MAIN LOOP         #
# ======================== #

loop do
  case event = SDL::Event.poll
  when SDL::Event::Quit
    break
  end

  # draw all objects
  LOOP.each do |thing|
    thing.update
  end

  # Set background to black
  RENDERER.draw_color = SDL::Color[0, 0, 0, 255]
  RENDERER.clear

  # draw all objects
  LOOP.each do |thing|
    thing.draw
  end

  # finalise
  RENDERER.present
end
