require "sdl/sdl"
require "sdl/image"
require "./leafgem/math"
require "./leafgem/library"

# ======================== #
#      LEAFGEM MODULE      #
# ======================== #
# Offt this is hella big and hella messy

module Leafgem
  class Spritesheet
    @sprite : SDL::Texture
    @quads = [] of SDL::Rect

    getter sprite
    getter quads

    # How do you make a "Class variable initializer?"
    def initialize(texture : String, width : Int32, height : Int32)
      @sprite = AssetManager.image(texture)
      @quads = Spritesheet.make_quads(@sprite.width, @sprite.height, width, height)
    end

    def self.make_quads(sprite_width : Int32, sprite_height : Int32, width : Int32, height : Int32) : Array(SDL::Rect)
      outputquads = [] of SDL::Rect
      (0..(sprite_height / height) - 1).each do |j|
        (0..(sprite_width / width) - 1).each do |i|
          outputquads << SDL::Rect[i*width, j*height, width, height]
        end
      end
      return outputquads
    end
  end

  class Object
    @spritesheet : Spritesheet?
    @sprite_index = 0.0
    @image_speed = 0.0
    property x = 0
    property y = 0
    property spritesheet
    property image_speed
    @anim_start_frame = 0
    @anim_end_frame = 0

    def update
    end

    def draw
      if spr = @spritesheet
        @sprite_index += @image_speed
        if (@sprite_index > @anim_end_frame - @anim_start_frame + 1)
          @sprite_index = 0
        end
        Leafgem::Game.renderer.copy(
          spr.sprite,
          spr.quads[@anim_start_frame + @sprite_index.to_i],
          SDL::Rect.new(@x.to_i, @y.to_i, spr.quads[0].w, spr.quads[0].h)
        )
      end
    end

    def set_animation(cols : Range(Int32, Int32), param_row = 0)
      cols = cols.to_a
      if param_row != 0
        if spritesheet = @spritesheet
          offset_y = (spritesheet.sprite.width / spritesheet.quads[0].w).to_i * param_row
          @anim_start_frame = offset_y + cols[0]
          @anim_end_frame = offset_y + cols[cols.size - 1]
        end
      else
        @anim_start_frame = cols[0]
        @anim_end_frame = cols[cols.size - 1]
      end
    end
  end

  class Game
    @@loop = [] of Object
    @@loopfunc : Proc(Nil)?

    @@renderer = SDL::Renderer.new(
      SDL::Window.new("Game", 640, 480),
      SDL::Renderer::Flags::ACCELERATED | SDL::Renderer::Flags::PRESENTVSYNC
    )

    def initialize(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Int32)
      SDL.init(SDL::Init::VIDEO); at_exit { SDL.quit }
      SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }

      @@renderer = SDL::Renderer.new(
        SDL::Window.new(window_title || "Game", window_width || 640, window_height || 480),
        SDL::Renderer::Flags::ACCELERATED | SDL::Renderer::Flags::PRESENTVSYNC
      )

      @@renderer.scale = {pixel_scale, pixel_scale}
    end

    # ======================== #
    #        MAIN LOOP         #
    # ======================== #

    def self.run
      loop do
        case event = SDL::Event.poll
        when SDL::Event::Quit
          break
        end

        if func = @@loopfunc
          func.call
        end

        # draw all objects
        Leafgem::Game.loop.each do |thing|
          thing.update
        end

        # Set background to black
        Leafgem::Game.renderer.draw_color = SDL::Color[0, 0, 0, 255]
        Leafgem::Game.renderer.clear

        # draw all objects
        Leafgem::Game.loop.each do |thing|
          thing.draw
        end

        # finalise
        Leafgem::Game.renderer.present
      end

      puts "Exiting..."
    end

    def self.set_loopfunc(function)
      @@loopfunc = function
    end

    def self.renderer
      @@renderer
    end

    def self.loop
      @@loop
    end
  end

  class AssetManager
    @@sprites = {} of Object.class => SDL::Texture

    def self.image(filename : String) : SDL::Texture
      # This empty string can be replaced with a special Leafgem
      # "no image" image file. Like, black + pink checkerboard lmao
      filename ||= ""
      puts filename
      SDL::IMG.load(File.join(__DIR__, filename), Leafgem::Game.renderer)
    end
  end
end
