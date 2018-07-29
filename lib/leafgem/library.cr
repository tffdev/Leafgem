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
  new_obj.init
  Leafgem::Game.loop << new_obj
end

def new_spritesheet(filepath : String, tilewidth : Int32, tileheight : Int32)
  Leafgem::Spritesheet.new(filepath, tilewidth, tileheight)
end

def keyboard_check_pressed(keycode : String)
  if Leafgem::KeyManager.keys_pressed.has_key?(keycode.downcase)
    Leafgem::KeyManager.keys_pressed[keycode.downcase][0]
  else
    false
  end
end

def keyboard_check(keycode : String)
  if Leafgem::KeyManager.keys_pressed.has_key?(keycode.downcase)
    Leafgem::KeyManager.keys_pressed[keycode.downcase][1]
  else
    false
  end
end

def set_loop_function(function : Proc(Void))
  Leafgem::Game.set_loopfunc(function)
end

def draw_sprite(filename : String, x : Float32 = 0, y : Float32 = 0, alpha : Float32 = 1)
  # literally just drawing a sprite
  image = Leafgem::AssetManager.image(filename)
  image.alpha_mod = alpha*255
  Leafgem::Game.renderer.copy(
    image,
    SDL::Rect.new(0, 0, image.width, image.height),
    SDL::Rect.new(x.to_i, y.to_i, image.width, image.height)
  )
end

def create_window(window_title : String, window_width : Int32, window_height : Int32, scale : Float32)
  title = window_title || "Leafgem Game " + Leafgem_Version
  width = window_width || 640
  height = window_height || 480
  Leafgem::Game.new(title, width, height, scale)
end
