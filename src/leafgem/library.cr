require "./library/*"

# all the goofy global functions that are
# essentially simple wrappers around less intuitive
# actions.
module Leafgem::Library
  # include Leafgem::Mouse::WheelManager

  # Begins to run the gameloop
  #
  # ```
  # require "leafgem"
  # include Leafgem::Library
  # set_window("Hello world!", 320, 240, 3)
  #
  # game_run
  # ```
  def game_run
    Leafgem::Game.run
  end

  # Ends the gameloop
  def game_exit
    Leafgem::Game.quit
  end

  # Will call the given function every frame **before** every object starts updating
  def set_loop_function(function : Proc(Void))
    Leafgem::Game.set_loopfunc(function)
  end

  # Creates a window for our game.
  #
  # In order, parameters are the title of the window, the width in pixels, the height in pixels, and the scale which sprites and shapes will be drawn;
  #
  # For example, if set to 2.0, sprites will appear twice as big. (For best results, use an integer)
  #
  # NOTE: These parameters are immuteable
  def set_window(window_title : String, window_width : Int32, window_height : Int32, scale : Float32 = 1.0)
    title = window_title || "Leafgem Game"
    width = window_width || 640
    height = window_height || 480
    Leafgem::Renderer.create(title, width, height, scale)
  end

  # Gets the screen width
  def screen_width
    Leafgem::Renderer.size.x
  end

  # Gets the screen height
  def screen_height
    Leafgem::Renderer.size.y
  end

  # Set or unset fullscreen
  def set_fullscreen(bool : Bool)
    if (win = Leafgem::Renderer.window)
      win.fullscreen = (bool) ? SDL::Window::Fullscreen::FULLSCREEN_DESKTOP : SDL::Window::Fullscreen::WINDOW
    end
  end

  # Adds the given object to gameworld at the given coordinates
  #
  # ```
  # create_object(Player, 100, 100)
  # ```
  def create_object(thing, x = 0, y = 0)
    # Give objects a unique identifier on create?
    new_obj = thing.new
    new_obj.pos.x = x.to_f
    new_obj.pos.y = y.to_f
    # new_obj.update_spritesheet
    new_obj.init

    if !Leafgem::Game.loop.has_key?(thing.to_s)
      Leafgem::Game.loop[thing.to_s] = [] of Leafgem::Object
    end
    Leafgem::Game.loop[thing.to_s].push(new_obj)
  end

  # Destroys the given object from the `Game`
  #
  # ```
  # player = create_object(Player, 100, 100)
  # destroy(player)
  # ```
  def destroy(thing : Leafgem::Object)
    Leafgem::Game.to_destroy.push(thing)
  end

  # Returns an array of IDs for every instance of a class that currently exists in the gameworld.
  def get(object_class)
    Leafgem::Game.loop[object_class.to_s]
  end

  # Creates and returns a new `Spritesheet`
  def new_spritesheet(filepath : String, tilewidth : Int32, tileheight : Int32)
    Leafgem::Spritesheet.new(filepath, tilewidth, tileheight)
  end

  # Leads an image from a path and returns and `SDL::Surface`
  def sprite(filepath : String)
    Leafgem::AssetManager.image(filepath)
  end

  # Sets the draw color for `Renderer`
  def set_draw_color(r : Int32, g : Int32, b : Int32, a : Int32 = 255)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.draw_color = SDL::Color.new(r, g, b, a)
    end
  end

  # Ditto
  def set_draw_color(color_tuple)
    out_color = SDL::Color.new(*color_tuple)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.draw_color = out_color
    end
  end

  # Sets the background color for the `Renderer`
  def set_background_color(r : Int32, g : Int32, b : Int32)
    Leafgem::Renderer.set_background_color(r, g, b)
  end

  # Fills a rectangle based on the position, and size
  def fill_rect(x, y, w, h, ignore_camera = false)
    Leafgem::Draw.fill_rect(x, y, w, h, ignore_camera = false)
  end

  # Draws (outlines) a rectangle based on the position, and size
  def draw_rect(x, y, w, h, ignore_camera = false)
    Leafgem::Draw.draw_rect(x, y, w, h, ignore_camera = false)
  end

  # Fills a circle based on the position and radius
  def fill_circ(x, y, r)
    raise Exception.new(Leafgem_errors["circ_invalid_radius"]) if (r < 0)
    Leafgem::Draw.fill_circ(x, y, r)
  end

  # Draws (outlines) a circle based on the position and radius
  def draw_circ(x, y, r)
    raise Exception.new(Leafgem_errors["circ_invalid_radius"]) if (r < 0)
    Leafgem::Draw.sprite_circ(x, y, r)
  end

  # NOTE: wowee this is super messy
  # Draws a sprite
  def draw_sprite(texture : SDL::Surface, x = 0, y = 0, alpha = 255, xscale = 1, yscale = 1, gui = false)
    alpha = Math.min(alpha.to_f, 255)
    texture.alpha_mod = alpha
    Leafgem::Draw.sprite(
      texture,
      0, 0,
      x, y, texture.width, texture.height,
      xscale, yscale,
      gui)
  end

  # Draws a sprite from a file
  def draw_sprite(file : String, x = 0, y = 0, alpha = 255, gui = false)
    alpha = Math.min(alpha.to_f, 255)
    if (tex = Leafgem::AssetManager.image(file))
      tex.alpha_mod = alpha
      Leafgem::Draw.sprite(
        tex,
        0, 0,
        x, y, tex.width, tex.height, gui)
    end
  end

  # Enable or disable rendering of debug hitboxes
  def debug_show_hitboxes(bool : Bool)
    Leafgem::Game.show_hitboxes(bool)
  end

  # Is the key pressed?
  def key_pressed?(keycode : String)
    Leafgem::KeyManager.key_is_pressed(keycode.downcase)
  end

  # Is the key held?
  def key?(keycode : String)
    Leafgem::KeyManager.key_is_held(keycode.downcase)
  end

  # Get the camera position
  def camera
    Leafgem::Renderer.camera.pos
  end

  # Plays a sound from a filename
  def play_sound(filename : String)
    Leafgem::Audio.play_sound(filename)
  end

  # Plays music from a filename
  def play_music(filename : String)
    Leafgem::Audio.play_music(filename)
  end

  # Fades out the music
  def fade_out_music(seconds)
    Leafgem::Audio.fade_out_music(seconds.to_f32)
  end

  # Camera x position
  def camera_x
    Leafgem::Renderer.camera.pos.x
  end

  # Set the camera x position
  def set_camera_x(x)
    Leafgem::Renderer.camera.posbuffer.x = x.to_f
  end

  # Camera y position
  def camera_y
    Leafgem::Renderer.camera.pos.y
  end

  # Set the camera y position
  def set_camera_y(y)
    Leafgem::Renderer.camera.posbuffer.y = y.to_f
  end

  # Lineral interpolation
  def lerp(a, b, t)
    return a + (b - a) * t
  end

  # Restrict a value between the min and the max value
  def clamp(val, min, max)
    return Math.max(Math.min(val, max), min)
  end

  # NOTE: bad system, bad boolean AAAAAAAAaAAA
  def sign(val)
    if (val > 0)
      1
    elsif (val < 0)
      -1
    else
      0
    end
  end

  # Display debug text
  def debug(text)
    Leafgem::Game.debug(text.to_s)
  end

  # Load a map from a filename
  def load_map(filename)
    Leafgem::Map.loadmap(filename)
  end

  extend self
end
