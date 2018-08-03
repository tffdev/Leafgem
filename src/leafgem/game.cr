# TODO
# [ ] set default background colours
# [ ] multiple object layers, objects have draw depth + priority

# there's no "get ticks" binding in the SDL library lmao
lib LibSDL
  fun ticks = SDL_GetTicks : Int32
end

class Leafgem::Game
  @@loop = [] of Object
  @@loopfunc : Proc(Nil)?
  @@fps = 60
  @@renderer : SDL::Renderer?
  @@window : SDL::Window?

  @@camera_x = 0
  @@camera_y = 0

  def self.create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32)
    SDL.init(SDL::Init::VIDEO | SDL::Init::AUDIO); at_exit { SDL.quit }
    SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }
    SDL::Mix.open; at_exit { SDL::Mix.quit }

    # Create window
    @@window = SDL::Window.new(window_title, window_width, window_height)

    # Create renderer
    flags = SDL::Renderer::Flags::ACCELERATED
    if (window = @@window)
      @@renderer = SDL::Renderer.new(window, flags)
    end
    # Set renderer pixel scale
    if a = @@renderer
      a.scale = {pixel_scale, pixel_scale}
    end
  end

  # ======================== #
  #        MAIN LOOP         #
  # ======================== #

  def self.run
    starttime = 0
    loop do
      if (starttime + 1000/@@fps <= LibSDL.ticks)
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
        Leafgem::Game.renderer.draw_color = SDL::Color[0, 0, 0, 255]
        Leafgem::Game.renderer.clear

        # Draw map
        Leafgem::Map.draw

        # draw all objects
        Leafgem::Game.loop.each do |thing|
          thing.draw
        end

        # finalise
        Leafgem::Game.renderer.present
        # reset pressed keys
        Leafgem::KeyManager.clear_pressed

        # wait until we wanna show the next frame
        GC.collect
      end
    end
  end

  def self.set_loopfunc(function)
    @@loopfunc = function
  end

  def self.renderer
    if a = @@renderer
      a
    else
      puts "Have not initialized renderer!"
      exit
    end
  end

  def self.loop
    @@loop
  end

  def self.set_camera_x(x : Int32)
    @@camera_x = x
  end

  def self.set_camera_y(y : Int32)
    @@camera_y = y
  end

  def self.camera_x
    @@camera_x
  end

  def self.camera_y
    @@camera_y
  end
end
