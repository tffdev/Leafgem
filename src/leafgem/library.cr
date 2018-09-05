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
    new_obj.x = x.to_f
    new_obj.y = y.to_f
    new_obj.update_spritesheet
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

  def set_draw_color(r, g, b, a)
    # assuming color is a hex string
    out_color = SDL::Color.new(r, g, b, a)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.draw_color = out_color
    end
  end

  def set_draw_color(color_tuple)
    out_color = SDL::Color.new(*color_tuple)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.draw_color = out_color
    end
  end

  def fill_rect(x, y, w, h)
    Leafgem::Renderer.fill_rect(x, y, w, h)
  end

  def fill_circ(x, y, r)
    raise Exception.new(Leafgem_errors["circ_invalid_radius"]) if (r < 0)
    Leafgem::Renderer.fill_circ(x, y, r)
  end

  def draw_circ(x, y, r)
    raise Exception.new(Leafgem_errors["circ_invalid_radius"]) if (r < 0)
    Leafgem::Renderer.draw_circ(x, y, r)
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

  def keyboard_check(keycode : String)
    Leafgem::KeyManager.key_is_held(keycode.downcase)
  end

  def set_loop_function(function : Proc(Void))
    Leafgem::Game.set_loopfunc(function)
  end

  # wowee this is super messy
  def draw_sprite(file, x = 0, y = 0, alpha = 1.0)
    alpha = Math.min(alpha.to_f, 1.0)
    if (x > 320 || y > 240 || typeof(file) == Nil)
      return 0
    end

    if (file = file.as?(String | SDL::Texture))
      if (file = file.as?(SDL::Texture))
        image = file
      elsif (file = file.as?(String))
        image = Leafgem::AssetManager.image(file)
      end
      if (image.as?(SDL::Texture))
        if (texture = image.as(SDL::Texture))
          texture.alpha_mod = alpha*255
          Leafgem::Renderer.draw(
            texture,
            0, 0,
            x, y, texture.width, texture.height)
        end
      end
    end
  end

  def set_window(window_title : String, window_width : Int32, window_height : Int32, scale : Float32 = 1.0, smooth_camera : Bool = false)
    title = window_title || "Leafgem Game"
    width = window_width || 640
    height = window_height || 480
    Leafgem::Renderer.set_smooth_camera(true)
    Leafgem::Renderer.create(title, width, height, scale, smooth_camera)
  end

  def screen_width
    Leafgem::Renderer.width
  end

  def screen_height
    Leafgem::Renderer.height
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
    Leafgem::Renderer.camera_x
  end

  def set_camera_x(x)
    Leafgem::Renderer.camera_x = x
  end

  def camera_y
    Leafgem::Renderer.camera_y
  end

  def set_camera_y(y)
    Leafgem::Renderer.camera_y = y
  end

  def lerp(a, b, t)
    return a + (b - a) * t
  end

  def debug(text)
    Leafgem::Game.debug(text.to_s)
  end

  def load_map(filename)
    Leafgem::Map.loadmap(filename)
  end

  extend self
end
