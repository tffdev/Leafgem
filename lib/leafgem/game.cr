class Leafgem::Game
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
