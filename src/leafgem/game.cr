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
  SDL_BLENDMODE_BLEND = "SDL_BLENDMODE_BLEND"
end

class Leafgem::Game
  @@loop = {} of String => Array(Leafgem::Object)
  @@loopfunc : Proc(Nil)?

  @@font : SDL::Texture?
  @@show_hitboxes = false

  @@should_show_debugger = true
  @@should_sort_debugger = false
  @@debug_string_buffer = [] of String

  @@currentfps = 0
  @@to_destroy = [] of Leafgem::Object

  # ======================== #
  #        MAIN LOOP         #
  # ======================== #

  def self.run
    starttime = 0
    @@font = Leafgem::AssetManager.image("./src/leafgem/fixed.gif")
    loop do
      if (starttime + 1000/Leafgem::Renderer.fps <= LibSDL.ticks)
        @@currentfps = 1000/(LibSDL.ticks - starttime)
        starttime = LibSDL.ticks

        while (event = SDL::Event.poll)
          case event
          when SDL::Event::Quit
            puts "Exiting..."
            SDL.quit
            exit
          when SDL::Event::Keyboard
            Leafgem::KeyManager.update(event)
          when SDL::Event::MouseButton
            Leafgem::Mouse::ButtonManager.update(event)
          end
        end

        if func = @@loopfunc
          func.call
        end

        # update all objects
        Leafgem::Game.loop.each do |thingset|
          thingset[1].each do |thing|
            thing.update
          end
        end

        # set background to black
        Leafgem::Renderer.update_camera
        Leafgem::Renderer.renderer.draw_color = SDL::Color[255, 255, 255, 255]
        Leafgem::Renderer.renderer.clear

        # Draw map
        Leafgem::Map.draw

        # draw all objects
        Leafgem::Game.loop.each do |thingset|
          thingset[1].each do |thing|
            thing.draw
            if @@show_hitboxes && thing.x && thing.y && thing.w && thing.h
              set_draw_color(255, 0, 0, 100)
              draw_rect(thing.x.to_i, thing.y.to_i, thing.w.to_i, thing.h.to_i)
            end
          end
        end

        if (@@should_show_debugger)
          Leafgem::Game.draw_debug
        end

        # finalise
        Leafgem::Renderer.renderer.present

        # reset pressed keys
        Leafgem::KeyManager.clear_pressed

        Leafgem::Game.destroy_all_in_buffer

        GC.collect
      end
    end
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

  def self.to_destroy
    @@to_destroy
  end

  def self.destroy_all_in_buffer
    @@to_destroy.each do |thing|
      Leafgem::Game.loop[thing.class.to_s].delete(thing)
      if (Leafgem::Game.loop[thing.class.to_s].size == 0)
        puts "empty"
      end
    end
    @@to_destroy = [] of Leafgem::Object
  end

  def self.getfps
    @@currentfps
  end

  def self.error(idstring)
    puts "## GAME ERROR ##"
    puts Leafgem_errors[idstring]
    exit
  end
end
