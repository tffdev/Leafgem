class Leafgem::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?
  @@window : SDL::Window?

  @@camera_x = 0.0
  @@camera_y = 0.0
  @@camera_x_buffer = 0.0
  @@camera_y_buffer = 0.0

  def self.create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32)
    SDL.init(SDL::Init::VIDEO | SDL::Init::AUDIO); at_exit { SDL.quit }
    SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }
    SDL::Mix.open; at_exit { SDL::Mix.quit }

    # Create window
    @@window = SDL::Window.new(window_title, window_width, window_height)

    # Create renderer
    if (window = @@window)
      @@renderer = SDL::Renderer.new(window, SDL::Renderer::Flags::ACCELERATED)
    end
    # Set renderer pixel scale
    if renderer = @@renderer
      renderer.scale = {pixel_scale, pixel_scale}
    end
  end

  def self.draw(texture, sx, sy, x, y, w, h, ignore_camera = false)
    if (ignore_camera)
      Leafgem::Renderer.renderer.copy(
        texture,
        SDL::Rect.new(sx.to_i, sy.to_i, w, h),
        SDL::Rect.new(x.to_i, y.to_i, w, h)
      )
    else
      Leafgem::Renderer.renderer.copy(
        texture,
        SDL::Rect.new(sx.to_i, sy.to_i, w, h),
        SDL::Rect.new(x.to_i - camera_x.to_i, y.to_i - camera_y.to_i, w, h)
      )
    end
  end

  def self.update_camera
    @@camera_x = @@camera_x_buffer
    @@camera_y = @@camera_y_buffer
  end

  def self.renderer
    @@renderer
  end

  def self.renderer
    if a = @@renderer
      a
    else
      puts "Have not initialized renderer!"
      exit
    end
  end

  def self.set_camera_x(x)
    @@camera_x_buffer = x
  end

  def self.set_camera_y(y)
    @@camera_y_buffer = y
  end

  def self.camera_x
    @@camera_x
  end

  def self.camera_y
    @@camera_y
  end

  def self.fps
    @@fps
  end

  def self.set_fps(fps_to_set)
    @@fps = fps_to_set
  end
end
