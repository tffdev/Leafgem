require "./library/*"

module Leafgem::Library
  # include Leafgem::Mouse::WheelManager

  # ======================== #
  #         LIBRARY          #
  # ======================== #
  # Beginning of the publically accessible library,
  # all the goofy global functions that are
  # essentially simple wrappers around less intuitive
  # actions.
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

  def destroy(thing)
    Leafgem::Game.to_destroy.push(thing)
  end

  def get(object_class)
    Leafgem::Game.loop[object_class.to_s]
  end

  def new_spritesheet(filepath : String, tilewidth : Int32, tileheight : Int32)
    Leafgem::Spritesheet.new(filepath, tilewidth, tileheight)
  end

  def sprite(filepath : String)
    Leafgem::AssetManager.image(filepath)
  end

  def set_draw_color(r : Int32, g : Int32, b : Int32, a : Int32 = 255)
    # assuming color is a hex string
    if (lgr = Leafgem::Renderer.renderer)
      lgr.draw_color = SDL::Color.new(r, g, b, a)
    end
  end

  def set_draw_color(color_tuple)
    out_color = SDL::Color.new(*color_tuple)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.draw_color = out_color
    end
  end

  def fill_rect(x, y, w, h, ignore_camera = false)
    Leafgem::Draw.fill_rect(x, y, w, h, ignore_camera = false)
  end

  def draw_rect(x, y, w, h, ignore_camera = false)
    Leafgem::Draw.draw_rect(x, y, w, h, ignore_camera = false)
  end

  def fill_circ(x, y, r)
    raise Exception.new(Leafgem_errors["circ_invalid_radius"]) if (r < 0)
    Leafgem::Draw.fill_circ(x, y, r)
  end

  def draw_circ(x, y, r)
    raise Exception.new(Leafgem_errors["circ_invalid_radius"]) if (r < 0)
    Leafgem::Draw.sprite_circ(x, y, r)
  end

  def debug_show_hitboxes(bool)
    Leafgem::Game.show_hitboxes(bool)
  end

  def key_pressed?(keycode : String)
    Leafgem::KeyManager.key_is_pressed(keycode.downcase)
  end

  def key?(keycode : String)
    Leafgem::KeyManager.key_is_held(keycode.downcase)
  end

  def set_loop_function(function : Proc(Void))
    Leafgem::Game.set_loopfunc(function)
  end

  # wowee this is super messy
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

  def set_window(window_title : String, window_width : Int32, window_height : Int32, scale : Float32 = 1.0)
    title = window_title || "Leafgem Game"
    width = window_width || 640
    height = window_height || 480
    Leafgem::Renderer.create(title, width, height, scale)
  end

  def camera
    Leafgem::Renderer.camera.pos
  end

  def screen_width
    Leafgem::Renderer.size.x
  end

  def screen_height
    Leafgem::Renderer.size.y
  end

  def set_fullscreen(bool)
    if (win = Leafgem::Renderer.window)
      win.fullscreen = (bool) ? SDL::Window::Fullscreen::FULLSCREEN_DESKTOP : SDL::Window::Fullscreen::WINDOW
    end
  end

  def play_sound(filename : String)
    Leafgem::Audio.play_sound(filename)
  end

  def play_music(filename : String)
    Leafgem::Audio.play_music(filename)
  end

  def fade_out_music(seconds)
    Leafgem::Audio.fade_out_music(seconds.to_f32)
  end

  def camera_x
    Leafgem::Renderer.camera.pos.x
  end

  def set_camera_x(x)
    Leafgem::Renderer.camera.posbuffer.x = x.to_f
  end

  def camera_y
    Leafgem::Renderer.camera.pos.y
  end

  def set_camera_y(y)
    Leafgem::Renderer.camera.posbuffer.y = y.to_f
  end

  def lerp(a, b, t)
    return a + (b - a) * t
  end

  def clamp(val, min, max)
    return Math.max(Math.min(val, max), min)
  end

  def sign(val)
    if (val > 0)
      1
    elsif (val < 0)
      -1
    else
      0
    end
  end

  def debug(text)
    Leafgem::Game.debug(text.to_s)
  end

  def load_map(filename)
    Leafgem::Map.loadmap(filename)
  end

  extend self
end
