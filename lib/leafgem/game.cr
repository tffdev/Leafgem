# TODO
# - Able to set default background programatically ?
#

class Leafgem::Game
  @@loop = [] of Object
  @@loopfunc : Proc(Nil)?

  @window : SDL::Window
  @@renderer : SDL::Renderer?

  def initialize(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32)
    SDL.init(SDL::Init::VIDEO); at_exit { SDL.quit }
    SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }

    # Create window
    @window = SDL::Window.new(window_title, window_width, window_height)

    # Create renderer
    flags = SDL::Renderer::Flags::ACCELERATED | SDL::Renderer::Flags::PRESENTVSYNC
    @@renderer = SDL::Renderer.new(@window, flags)

    # Set renderer pixel scale
    if a = @@renderer
      a.scale = {pixel_scale, pixel_scale}
    end
  end

  # ======================== #
  #        MAIN LOOP         #
  # ======================== #

  def self.run
    loop do
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

      # draw all objects
      Leafgem::Game.loop.each do |thing|
        thing.draw
      end

      # finalise
      Leafgem::Game.renderer.present
      # reset pressed keys
      Leafgem::KeyManager.clear_pressed
    end
  end

  def self.set_loopfunc(function)
    @@loopfunc = function
  end

  def self.renderer
    if a = @@renderer
      a
    else
      exit()
    end
  end

  def self.loop
    @@loop
  end
end
