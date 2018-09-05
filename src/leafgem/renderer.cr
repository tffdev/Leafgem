# TODO
# [ ] Allow the enabling of "smooth camera" vs "pixel-perfect camera"
lib LibSDL
end

class Leafgem::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?
  @@window : SDL::Window?
  @@scale = 2

  @@width = 0.0
  @@height = 0.0

  @@smoothcam = false
  @@smoothscale = 1

  @@camera_x = 0.0
  @@camera_y = 0.0

  @@camera_x_buffer = 0.0
  @@camera_y_buffer = 0.0

  def self.create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32, smooth_cam : Bool)
    # Create window
    @@window = SDL::Window.new(window_title, window_width, window_height)

    # Create renderer
    if (window = @@window)
      @@width = (window.width / pixel_scale).to_f
      @@height = (window.height / pixel_scale).to_f

      @@renderer = SDL::Renderer.new(window, SDL::Renderer::Flags::ACCELERATED)
      if renderer = @@renderer
        renderer.draw_blend_mode = LibSDL::BlendMode::BLEND
      end
    end
    # Set renderer pixel scale
    if (smooth_cam == true)
      @@smoothscale = pixel_scale
    elsif renderer = @@renderer
      renderer.scale = {pixel_scale, pixel_scale}
    end
  end

  def self.draw(texture, sx, sy, x, y, w, h, ignore_camera = false)
    if (ignore_camera)
      Leafgem::Renderer.renderer.copy(
        texture,
        SDL::Rect.new(sx.to_i, sy.to_i, w, h),
        SDL::Rect.new((x*@@smoothscale).to_i, (y*@@smoothscale).to_i, (w*@@smoothscale).to_i, (h*@@smoothscale).to_i)
      )
    else
      Leafgem::Renderer.renderer.copy(
        texture,
        SDL::Rect.new(sx.to_i, sy.to_i, w, h),
        SDL::Rect.new((x*@@smoothscale).to_i - (camera_x*@@smoothscale).to_i, (y*@@smoothscale).to_i - (camera_y*@@smoothscale).to_i, (w*@@smoothscale).to_i, (h*@@smoothscale).to_i)
      )
    end
  end

  def self.fill_rect(x, y, w, h)
    rect = SDL::Rect.new((x*@@smoothscale).to_i - (camera_x*@@smoothscale).to_i, (y*@@smoothscale).to_i - (camera_y*@@smoothscale).to_i, (w*@@smoothscale).to_i, (h*@@smoothscale).to_i)
    Leafgem::Renderer.renderer.fill_rect(rect.x, rect.y, rect.w, rect.h)
  end

  def self.update_camera
    @@camera_x = @@camera_x_buffer
    @@camera_y = @@camera_y_buffer
  end

  def self.renderer
    @@renderer
  end

  def self.window
    @@window
  end

  def self.renderer
    if a = @@renderer
      a
    else
      Leafgem::Game.error("no_renderer")
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

  def self.width
    @@width
  end

  def self.height
    @@height
  end

  def self.scale
    @@scale
  end

  def self.fps
    @@fps
  end

  def self.set_fps(fps_to_set)
    @@fps = fps_to_set
  end

  def self.set_smooth_camera(bool)
    @@smoothcam = bool
  end
end
