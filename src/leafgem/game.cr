# TODO
# [ ] set default background colours
# [ ] multiple object layers, objects have draw depth + priority

DEBUG_ALPHA =
  " ΔΔΔΔΔΔΔΔΔΔΔΔΔΔΔ" \
  "ΔΔΔΔΔΔΔΔΔΔΔΔΔΔΔΔ" \
  " !+#$%&'()*+,-./" \
  "0123456789:;<=>?" \
  "@ABCDEFGHIJKLMNO" \
  "PQRSTUVWXYZ[\\]^_" \
  "`abcdefghijklmno" \
  "pqrstuvwxyz{|}~ "

# there's no "get ticks" binding in the SDL library lmao
lib LibSDL
  fun ticks = SDL_GetTicks : Int32
end

class Leafgem::Game
  @@loop = [] of Object
  @@loopfunc : Proc(Nil)?

  @@font : SDL::Texture?

  @@should_show_debugger = true
  @@should_sort_debugger = false
  @@debug_string_buffer = [] of String

  # ======================== #
  #        MAIN LOOP         #
  # ======================== #

  def self.run
    starttime = 0
    @@font = Leafgem::AssetManager.image("./src/leafgem/fixed.gif")
    loop do
      if (starttime + 1000/Leafgem::Renderer.fps <= LibSDL.ticks)
        debug("FPS: ~#{1000/(LibSDL.ticks - starttime)}")

        starttime = LibSDL.ticks

        while (event = SDL::Event.poll)
          case event
          when SDL::Event::Quit
            puts "Exiting..."
            SDL.quit
            exit
          when SDL::Event::Keyboard
            Leafgem::KeyManager.update(event)
          end
        end

        if func = @@loopfunc
          func.call
        end

        # update all objects
        Leafgem::Game.loop.each do |thing|
          thing.update
        end

        # set background to black
        Leafgem::Renderer.update_camera
        Leafgem::Renderer.renderer.draw_color = SDL::Color[0, 0, 0, 255]
        Leafgem::Renderer.renderer.clear

        # Draw map
        Leafgem::Map.draw

        # draw all objects
        Leafgem::Game.loop.each do |thing|
          thing.draw
        end

        if (@@should_show_debugger)
          Leafgem::Game.draw_debug
        end

        # finalise
        Leafgem::Renderer.renderer.present

        # reset pressed keys
        Leafgem::KeyManager.clear_pressed

        GC.collect
      end
    end
  end

  def self.set_loopfunc(function)
    @@loopfunc = function
  end

  def self.loop
    @@loop
  end

  def self.debug(string_to_show)
    @@debug_string_buffer << string_to_show
  end

  def self.draw_debug
    # sort debug buffer in alphabetical order
    if @@should_sort_debugger
      @@debug_string_buffer = @@debug_string_buffer.sort { |a, b| a <=> b }
    end

    old_scale = Leafgem::Renderer.renderer.scale
    Leafgem::Renderer.renderer.scale = {1, 1}
    # Draw debugging
    line = 0
    @@debug_string_buffer.each do |string|
      if font = @@font
        string.size.times do |i|
          if (a = DEBUG_ALPHA.index(string[i]))
            Leafgem::Renderer.renderer.copy(
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
    Leafgem::Renderer.renderer.scale = old_scale
    @@debug_string_buffer = [] of String
  end
end
