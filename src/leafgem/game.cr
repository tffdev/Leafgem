# TODO
# [ ] set default background colours
# [ ] multiple object layers, objects have draw depth + priority

DEBUG_ALPHA =
  " !+#$%&'()*+,-./" \
  "0123456789:;<=>?" \
  "@ABCDEFGHIJKLMNO" \
  "PQRSTUVWXYZ[\\]^_" \
  "`abcdefghijklmno" \
  "pqrstuvwxyz{|}~ "

# there's no "get ticks" binding in the SDL library lmao
lib LibSDL
  fun ticks = SDL_GetTicks : Int32
  SDL_BLENDMODE_BLEND = "SDL_BLENDMODE_BLEND"
end

class Leafgem::Game
  @@loop = {} of String => Array(Leafgem::Object)
  @@loopfunc : Proc(Nil)?

  @@font : SDL::Surface?
  @@show_hitboxes = false

  @@should_show_debugger = true
  @@should_sort_debugger = false
  @@debug_string_buffer = [] of String

  @@currentfps = 0
  @@to_destroy = [] of Leafgem::Object
  @@quit = false

  # ======================== #
  #        MAIN LOOP         #
  # ======================== #

  def self.run
    starttime = 0

    if (Leafgem::Renderer.renderer)
      @@font = Leafgem::AssetManager.image("./src/leafgem/debug_font.gif")
    end

    loop do
      if (starttime + 1000/Leafgem::Renderer.fps <= LibSDL.ticks)
        @@currentfps = 1000/(LibSDL.ticks - starttime)
        starttime = LibSDL.ticks
        self.game_update
        break if @@quit
      end
    end

    # exit code
    if window = Leafgem::Renderer.window
      window.destroy
    end
    if renderer = Leafgem::Renderer.renderer
      renderer.finalize
    end
    puts "Exiting..."
    SDL.quit
    exit
  end

  def self.game_update
    while (event = SDL::Event.poll)
      case event
      when SDL::Event::Quit
        @@quit = true
      when SDL::Event::Keyboard
        Leafgem::KeyManager.update(event)
      when SDL::Event::MouseButton
        Leafgem::Library::Mouse.update(event)
      when SDL::Event::MouseMotion
        Leafgem::Library::Mouse.update(event)
      when SDL::Event::MouseWheel
        Leafgem::Library::Mouse.update(event)
      end
    end

    Leafgem::Renderer.camera.update

    if func = @@loopfunc
      func.call
    end

    # update all objects
    Leafgem::Game.loop.each do |set_of_objects|
      set_of_objects[1].each do |object|
        object.update
      end
    end

    Leafgem::Renderer.camera.update
    Leafgem::Renderer.clear_screen(0, 0, 0)
    Leafgem::Map.draw

    # draw all objects
    Leafgem::Game.loop.each do |set_of_objects|
      set_of_objects[1].each do |object|
        object.draw

        if @@show_hitboxes
          if hb = object.hitbox
            Leafgem::Library.set_draw_color(255, 0, 0, 100)
            Leafgem::Draw.fill_rect(object.pos.x + hb.pos.x, object.pos.y + hb.pos.y, hb.size.x.to_i, hb.size.y.to_i)
          end
        end
      end
    end

    # Hide parts of window that shouldn't be shown due to resizing
    Leafgem::Renderer.draw_buffer

    if (@@should_show_debugger)
      Leafgem::Game.draw_debug
    end

    # finalise
    Leafgem::Renderer.present
    # reset pressed keys
    Leafgem::KeyManager.clear_pressed

    # remove any items that are to be deleted
    Leafgem::Game.destroy_all_in_buffer

    # Update the mouse
    Leafgem::Library::Mouse.update
  end

  def self.set_loopfunc(function)
    @@loopfunc = function
  end

  def self.show_hitboxes(bool)
    @@show_hitboxes = bool
  end

  def self.loop
    @@loop
  end

  def self.debug(string_to_show)
    @@debug_string_buffer << string_to_show
  end

  def self.draw_debug
    if (lgr = Leafgem::Renderer.renderer)
      # sort debug buffer in alphabetical order
      if @@should_sort_debugger
        @@debug_string_buffer = @@debug_string_buffer.sort { |a, b| a <=> b }
      end

      old_scale = lgr.scale
      lgr.scale = {1, 1}
      # Draw debugging
      line = 0
      @@debug_string_buffer.each do |string|
        if font = @@font
          string.size.times do |i|
            if (a = DEBUG_ALPHA.index(string[i]))
              lgr.copy(
                font,
                SDL::Rect.new(
                  (a % 16)*12, (a/16)*13, 6, 13),
                SDL::Rect.new(
                  3 + i*6, 3 + line*14, 6, 13)
              )
            end
          end
        end
        line += 1
      end
      lgr.scale = old_scale
      @@debug_string_buffer = [] of String
    end
  end

  def self.to_destroy
    @@to_destroy
  end

  def self.destroy_all_in_buffer
    @@to_destroy.each do |thing|
      Leafgem::Game.loop[thing.class.to_s].delete(thing)
      if (Leafgem::Game.loop[thing.class.to_s].size == 0)
        # clear hash key?
      end
    end
    @@to_destroy = [] of Leafgem::Object
  end

  def self.getfps
    @@currentfps
  end
end
